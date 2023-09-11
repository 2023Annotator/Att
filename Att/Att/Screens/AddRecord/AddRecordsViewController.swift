//
//  AddRecordsViewController.swift
//  Att
//
//  Created by 정제인 on 2023/09/06.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

class AddRecordsViewController: UIViewController {
    
    
    // 좌측 뒤로가기버튼
    private let chevronButton: UIBarButtonItem = {
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
        /// progress 배경 색상
        view.trackTintColor = .white
        /// progress 진행 색상
        view.progressTintColor = .blue
        view.progress = 0.6
        
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
        label.text = "Records"
        
        return label
    }()
    
    private lazy var recordExplainLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle3
        label.textAlignment = .center
        label.textColor = .white
        label.text = "오늘의 일기"
        
        return label
    }()
    
    private lazy var recordExplain2Label: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        label.text = "당신의 이야기를 들려주세요"
        
        return label
    }()
    
    private lazy var addRecordTextFieldView: AddRecordTextFieldView = {
        let view = AddRecordTextFieldView()
        return view
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
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = chevronButton
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
                recordExplainLabel,
                recordExplain2Label,
                addRecordTextFieldView,
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
        
        addRecordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(recordExplain2Label.snp.bottom).offset(constraints.space100)
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
                self.navigationController?.pushViewController(AddWordsViewController(), animated: false)
            }.store(in: &cancellables)
    }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }
    
    
    private func setBtnTap() {
        //present 방식

        let svc = AddWordsViewController() //modalTransitionStyle은 원하는 거 선택
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: true, completion: nil)
    }
    
}
