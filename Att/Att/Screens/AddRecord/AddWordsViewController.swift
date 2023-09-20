//
//  AddWordsViewController.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

final class AddWordsViewController: UIViewController {
    
    private let xmarkButton: UIBarButtonItem = {
        let testImage = UIImage()
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .green
        view.progress = 0.8
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
        label.text = "Words"
        return label
    }()
    
    private lazy var recordExplainLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle2
        label.textAlignment = .center
        label.textColor = .white
        label.text = "내일의 나에게"
        return label
    }()
    
    private lazy var recordExplain2Label: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        label.text = "오늘의 당신이, 내일의 당신에게\n전달하고 싶은 한 마디를 적어주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var addRecordTextFieldView: AddRecordTextFieldView = {
        let view = AddRecordTextFieldView()
        return view
    }()
    
    private lazy var nextButton: NextButtonView = {
        let button = NextButtonView(title: "다음")
        return button
    }()
    
    private var viewModel: TestViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
            recordExplain2Label,
            addRecordTextFieldView
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
            make.top.equalTo(recordExplain2Label.snp.bottom).offset(constraints.space80)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-constraints.space54)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpStyle() {
        view.backgroundColor = .black
    }
    
    private func setUpAction() {
        nextButton.tapPublisher
            .sink {
                self.navigationController?.pushViewController(AddRecordFinishViewController(), animated: true)
            }.store(in: &cancellables)
        
        xmarkButton.tapPublisher
            .sink {
                self.navigationController?.dismiss(animated: true)
            }.store(in: &cancellables)
    }
    
    private func bind() { }
}
