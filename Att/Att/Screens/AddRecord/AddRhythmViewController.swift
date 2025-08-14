//
//  AddRhythmViewController.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

final class AddRhythmViewController: UIViewController {
    
    private let imageLoader: ImageLoader = DefaultImageLoader() // 메모리 캐시만(ephemeral)
    private var artworkTask: Task<Void, Never>?
    private var currentArtworkURL: URL?

    private let xmarkButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?
            .withTintColor(.green, renderingMode: .alwaysOriginal))
        return button
    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .green
        view.progress = 0.4
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.font = .title1
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Rhythm"
        return label
    }()
    
    private lazy var recordExplainLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle3
        label.textAlignment = .center
        label.textColor = .white
        label.text = "오늘의 음악"
        return label
    }()
    
    private lazy var recordDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        label.text = "당신의 하루를 표현할 수 있는\n음악을 골라주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var addMusicButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 42.0))
        let image = UIImage(systemName: "plus")?
            .withTintColor(.green, renderingMode: .alwaysOriginal)
            .withConfiguration(config)
        button.setImage(image, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var musicDescriptionView: MusicDescriptionView = {
        let view = MusicDescriptionView()
        view.alpha = 0.0
        return view
    }()
    
    private lazy var nextButton: NextButton = {
        let button = NextButton(title: "다음")
        return button
    }()
    
    private var recordCreationViewModel: RecordCreationViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(recordCreationViewModel: RecordCreationViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.recordCreationViewModel = recordCreationViewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItem = xmarkButton
    }
    
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpNavigationBar()
        setUpAction()
        bind()
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(view.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height)
        }
        
        [
            progressView,
            recordLabel,
            recordExplainLabel,
            recordDescriptionLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        let itemWidth = UIScreen.main.bounds.width * 0.85
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(constraints.space18)
            make.width.equalTo(itemWidth)
            make.height.equalTo(4)
        }
        progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        recordLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(constraints.space42)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        recordExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(recordLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        recordDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(recordExplainLabel.snp.bottom).offset(constraints.space28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        
        view.addSubview(addMusicButton)
        addMusicButton.snp.makeConstraints { make in
            make.top.equalTo(recordDescriptionLabel.snp.bottom).offset(constraints.space80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(258)
        }
        
        view.addSubview(musicDescriptionView)
        musicDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(addMusicButton.snp.bottom).offset(constraints.space12)
            make.directionalHorizontalEdges.equalTo(addMusicButton.snp.directionalHorizontalEdges)
            make.height.equalTo(60)
        }
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(constraints.space20)
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(48)
        }
    }
    
    private func setUpStyle() {
        view.backgroundColor = .black
    }
    
    private func setUpAction() {
        nextButton.tapPublisher
            .sink { [weak self] in
                self?.navigationController?.pushViewController(AddRecordsViewController(recordCreationViewModel: self?.recordCreationViewModel), animated: true)
            }.store(in: &cancellables)
        
        xmarkButton.tapPublisher
            .sink {
                self.navigationController?.dismiss(animated: true)
            }.store(in: &cancellables)
        
        addMusicButton.tapPublisher
            .sink { [weak self] in
                self?.presentMusicSearchViewController()
            }.store(in: &cancellables)
    }
    
    private func bind() {
        recordCreationViewModel?.$dailyRecord
            .compactMap { $0.musicInfo }
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                guard let self = self else { return }
                
                // 텍스트 먼저
                self.presentmusicDescriptionView(title: info.title, artist: info.artist)

                // 이전 로딩 취소 + 현재 URL 기억
                self.artworkTask?.cancel()
                self.currentArtworkURL = info.artworkURL

                // 기본 아이콘(플레이스홀더)
                let plus = UIImage(systemName: "plus")?
                    .withTintColor(.green, renderingMode: .alwaysOriginal)
                    .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 42)))
                self.addMusicButton.setImage(plus, for: .normal)

                // URL 없으면 여기서 끝
                guard let url = info.artworkURL else { return }

                // 1) 캐시 히트면 즉시 적용
                if let cached = self.imageLoader.cachedImage(for: url) {
                    self.addMusicButton.setImage(cached, for: .normal)
                    return
                }

                // 2) 미스면 비동기 로드
                self.artworkTask = Task { [weak self] in
                    guard let self = self else { return }
                    let img = try? await self.imageLoader.loadImage(from: url,
                                                                    targetPointSize: CGSize(width: 500, height: 500),
                                                                    screenScale: UIScreen.main.scale)

                    // 레이스 가드: 가장 최근 바인딩된 URL인지 확인
                    guard self.currentArtworkURL == url else { return }

                    await MainActor.run {
                        self.addMusicButton.setImage(img ?? plus, for: .normal)
                    }
                }
            }
            .store(in: &cancellables)
    }

}

extension AddRhythmViewController {
    func presentmusicDescriptionView(title: String?, artist: String?) {
        musicDescriptionView.setUpMusicInfo(title: title, artist: artist)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.musicDescriptionView.alpha = 1.0
        }
    }
}
extension AddRhythmViewController {
    func presentMusicSearchViewController() {
        let musicSearchViewController = UINavigationController(rootViewController: MusicSearchViewController(searchViewModel: AppFlow.makeSearchViewModel(), recordCreationViewModel: recordCreationViewModel))
        musicSearchViewController.modalPresentationStyle = .automatic
        present(musicSearchViewController, animated: true)
    }
}
