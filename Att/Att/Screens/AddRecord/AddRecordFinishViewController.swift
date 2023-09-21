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

final class AddRecordFinishViewController: UIViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let xmarkButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?
            .withTintColor(.green, renderingMode: .alwaysOriginal))
        return button
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
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
    
    private lazy var ticketImageView: UIImageView = {
        let image = UIImage(named: "ticket")
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let imageWithInset = image?.imageWithInset(insets: insets)
        let view = UIImageView()
        view.image = imageWithInset
        view.layer.cornerRadius = 70
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
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
    
    private lazy var finishButton: NextButton = {
        let button = NextButton(title: "완료")
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
        playTicketAnimation()
    }
    
    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItem = xmarkButton
    }
    
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpNavigationBar()
        setUpAction()
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
            ticketImageView,
            recordExplainLabel
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
        
        ticketImageView.snp.makeConstraints { make in
            make.top.equalTo(recordLabel.snp.bottom).offset(constraints.space142)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(140)
        }
        
        recordExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(ticketImageView.snp.bottom).offset(constraints.space12)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(finishButton)
        finishButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(constraints.space42)
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(48)
        }
    }
    
    private func setUpStyle() {
        view.backgroundColor = .black
    }
    
    private func setUpAction() {
        xmarkButton.tapPublisher
            .sink {
                self.navigationController?.dismiss(animated: true)
            }.store(in: &cancellables)
    }
    
    private func playTicketAnimation() {
        ticketImageView.rotateClockwise45Degrees { [weak self] _ in
            self?.presentRecordBrowseViewController()
        }
    }
    
    private func presentRecordBrowseViewController() {
        let viewController = RecordBrowseViewController(recordCreationViewModel: recordCreationViewModel)
        viewController.delegate = self
        viewController.modalPresentationStyle = .automatic
        present(viewController, animated: true)
    }
}

extension AddRecordFinishViewController: RecordBrowseViewControllerDelegate {
    func createDailyRecord() {
        guard let dailyRecord = recordCreationViewModel?.dailyRecord else { return }
        CoreDataManager.shared.createDailyRecord(dailyRecord: dailyRecord)
    }
    
    func dismissAddRecordViewController() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.dismiss(animated: true)
    }
}
