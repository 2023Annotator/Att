//
//  AddRecordFinishViewController.swift
//  Att
//
//  Created by 정제인 on 2023/09/18.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

class AddRecordFinishViewController: UIViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // 우측 close 버튼
    private let xmarkButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()

        /// progress 배경 색상
        view.trackTintColor = .white
        /// progress 진행 색상
        view.progressTintColor = .green
        view.progress = 1.0
        
        return view
    }()
    
    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.font = .title1
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Ticket"
        
        return label
    }()
    
    lazy var imageView: UIImageView = {

        // Set x, y of UIImageView.
        let posX: CGFloat = (self.view.bounds.width - 140)/2
        let posY: CGFloat = (self.view.bounds.height - 140)/2
            
        // Create UIImageView.
        let imageView = UIImageView(frame: CGRect(x: posX, y: posY, width: 140, height: 140))
        
        // Create UIImage.
        let image = UIImage(systemName: "ticket.fill")
        
            // Set the image to UIImageView.
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var recordExplainLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        label.text = "당신의 소중한 기억을 발권중입니다.\n잠시만 기다려주세요"
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var finishButton: NextButtonView = {
        let button = NextButtonView(title: "완료")
        return button
    }()
    
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
    
    private func setUpNavigationBar() {
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
            make.width.equalTo(view.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height)
        }
        [
                progressView,
                recordLabel,
                imageView,
                recordExplainLabel,
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
        imageView.snp.makeConstraints { make in
            make.top.equalTo(recordLabel.snp.bottom).offset(constraints.space142)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(140)
        }
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        recordExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(constraints.space12)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(finishButton)
        finishButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(constraints.space054)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpStyle() {
        view.backgroundColor = .black
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: TabPulisher etc - Optional
    private func setUpAction() {
        xmarkButton.tapPublisher
            .sink {
                self.navigationController?.dismiss(animated: true)
        }.store(in: &cancellables)
    }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }

}
