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
    
    private lazy var recordExplain2Label: UILabel = {
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
            recordExplain2Label
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
        
        recordExplain2Label.snp.makeConstraints { make in
            make.top.equalTo(recordExplainLabel.snp.bottom).offset(constraints.space28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        
        view.addSubview(addMusicButton)
        addMusicButton.snp.makeConstraints { make in
            make.top.equalTo(recordExplain2Label.snp.bottom).offset(constraints.space80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(258)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(constraints.space42)
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
            .sink { [weak self] record in
                guard let musicInfo = record.musicInfo else { return }
                self?.addMusicButton.setImage(musicInfo.thumbnailImage, for: .normal)
            }.store(in: &cancellables)
    }
}

extension AddRhythmViewController {
    func presentMusicSearchViewController() {
        let musicSearchViewController = UINavigationController(rootViewController: MusicSearchViewController(recordCreationViewModel: recordCreationViewModel, musicManager: MusicManager()))
        musicSearchViewController.modalPresentationStyle = .automatic
        present(musicSearchViewController, animated: true)
    }
}
