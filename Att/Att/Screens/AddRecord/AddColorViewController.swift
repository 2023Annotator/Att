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

class AddColorViewController: UIViewController {

    // 좌측 뒤로가기버튼
    private let backBarButtonItem: UIBarButtonItem = {
        
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        
        return button
    }()
    
    // 우측 close 버튼
    private let xmarkButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()

    // progress bar 들어가야함
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .blue
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
    
    private lazy var recordExplain2Label: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        label.text = "당신의 하루를 표현할 수 있는\n색상을 골라주세요."
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var imageView: UIImageView = {
        // Set the size of UIImageView.
        let width: CGFloat = 20
        let height: CGFloat = 30
            
        // Set x, y of UIImageView.
        let posX: CGFloat = (self.view.bounds.width - width)/2
        let posY: CGFloat = (self.view.bounds.height - height)/2
            
        // Create UIImageView.
        let imageView = UIImageView(frame: CGRect(x: posX, y: posY, width: width, height: height))
            
        // Create UIImage.
        let image = UIImage(systemName: "arrowtriangle.down.fill")
        
            // Set the image to UIImageView.
        imageView.image = image
        
        return imageView
    }()
    

    private lazy var circularSlider: CircularSlider = {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        var circularSlider = CircularSlider(frame: frame)
        
        circularSlider.unfilledArcLineCap = .round
        circularSlider.filledArcLineCap = .round
        circularSlider.currentValue = 10
        circularSlider.lineWidth = 54
                                            
        return circularSlider
    }()
    
    //다음 버튼
    private lazy var nextButton: NextButtonView = {
        let button = NextButtonView()
        return button
    }()
    
    
    private var viewModel: TestViewModel?
    private var cancellables = Set<AnyCancellable>()

    
//    private let textViewHeight: CGFloat = 48
    
    // MARK: Init 선언부
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle 선언부
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // Do any additional setup after loading the view.
    }
    // private var cancellables = Set<AnyCancellable>()
    
    private func setUpNavigationBar() {
        
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = xmarkButton
    }
    
    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
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
        contentView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(view.snp.height)
        }
        [
                progressView,
                recordLabel,
                recordExplainLabel,
                recordExplain2Label,
                imageView,
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
        recordExplain2Label.snp.makeConstraints { make in
            make.top.equalTo(recordExplainLabel.snp.bottom).offset(constraints.space28)
            make.leading.trailing.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(recordExplain2Label.snp.bottom).offset(constraints.space12)
        }
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    
        circularSlider.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(constraints.space42)
            make.height.equalTo(300)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(constraints.space054)
            make.leading.trailing.equalToSuperview()
        }
        
        
    }
    
    private func setUpStyle() {
        view.backgroundColor = .black
    }
    
    // MARK: TabPulisher etc - Optional
    private func setUpAction() {
        nextButton.tapPublisher
            .sink {
                let navVC = UINavigationController(rootViewController: AddRhythmViewController())
                navVC.modalPresentationStyle = .overFullScreen
                self.present(navVC, animated: false)

            }.store(in: &cancellables)
    }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }
    

    
}

