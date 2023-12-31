//
//  AddColorViewController.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//
import Combine
import CombineCocoa
import SnapKit
import UIKit

final class AddColorViewController: UIViewController {
    
    private let xmarkButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?
            .withTintColor(.green, renderingMode: .alwaysOriginal))
        return button
    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .green
        view.progress = 0.2
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
        label.text = "Moods"
        return label
    }()
    
    private lazy var recordExplainLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle3
        label.textAlignment = .center
        label.textColor = .white
        label.text = "오늘의 기분"
        return label
    }()
    
    private lazy var recordDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        label.text = "당신의 하루를 표현할 수 있는\n색상을 골라주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let width: CGFloat = 20
        let height: CGFloat = 30
        
        let posX: CGFloat = (self.view.bounds.width - width)/2
        let posY: CGFloat = (self.view.bounds.height - height)/2
        
        let imageView = UIImageView(frame: CGRect(x: posX, y: posY, width: width, height: height))
        
        let image = UIImage(systemName: "arrowtriangle.down.fill")?
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
        
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var circularSlider: CircularSlider = {
        let circularSlider = CircularSlider()
        circularSlider.backgroundArcLineCap = .round
        circularSlider.currentValue = 10
        circularSlider.lineWidth = 54
        return circularSlider
    }()
    
    private lazy var moodDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var moodSubDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle3
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var nextButton: NextButton = {
        let button = NextButton(title: "다음")
        return button
    }()
    
    private var recordCreationViewModel: RecordCreationViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(recordCreationViewModel: RecordCreationViewModel) {
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
            make.height.greaterThanOrEqualTo(view.snp.height)
        }
        
        [
            progressView,
            recordLabel,
            recordExplainLabel,
            recordDescriptionLabel,
            arrowImageView,
            circularSlider
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
        
        arrowImageView.snp.makeConstraints { make in
            make.top.equalTo(recordDescriptionLabel.snp.bottom).offset(constraints.space22)
            make.centerX.equalToSuperview()
        }
        
        circularSlider.snp.makeConstraints { make in
            make.top.equalTo(arrowImageView.snp.bottom).offset(constraints.space32)
            make.width.height.equalTo(300)
            make.leading.trailing.equalToSuperview()
        }
        
        let moodDescriptionStackView = UIStackView()
        moodDescriptionStackView.axis = .vertical
        moodDescriptionStackView.alignment = .center
        moodDescriptionStackView.distribution = .equalSpacing
        moodDescriptionStackView.spacing = constraints.space4
        
        view.addSubview(moodDescriptionStackView)
        moodDescriptionStackView.snp.makeConstraints { make in
            make.center.equalTo(circularSlider.snp.center)
            make.width.equalTo(circularSlider.snp.width)
            make.height.equalTo(48)
        }
        [
            moodDescriptionLabel,
            moodSubDescriptionLabel
        ].forEach {
            moodDescriptionStackView.addArrangedSubview($0)
        }
        
        moodDescriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
        }
        
        moodSubDescriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
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
                self?.navigationController?.pushViewController(AddRhythmViewController(recordCreationViewModel: self?.recordCreationViewModel), animated: true)
            }.store(in: &cancellables)
        
        xmarkButton.tapPublisher
            .sink { [weak self] in
                self?.navigationController?.dismiss(animated: true)
            }.store(in: &cancellables)
        
        circularSlider.addTarget(self, action: #selector(handleControlValueChanged), for: .valueChanged)
    }
    
    private func bind() {
        recordCreationViewModel?.$dailyRecord
            .sink { [weak self] record in
                self?.setUpComponent(mood: record.mood)
            }.store(in: &cancellables)
    }
    
    private func setUpComponent(mood: Mood?) {
        moodDescriptionLabel.text = mood?.description
        moodSubDescriptionLabel.text = mood?.subDescription
    }
    
}

extension AddColorViewController {
    @objc private func handleControlValueChanged(_ sender: CircularSlider?) {
        guard let currentValue = sender?.currentValue else { return }
        recordCreationViewModel?.setMoodWithSliderValue(with: currentValue)
    }
}
