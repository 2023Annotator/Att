//
//  ViewController.swift
//  Att
//
//  Created by 황정현 on 2023/07/09.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

final class ViewController: UIViewController {

    private lazy var sampleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Sample Button", for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var sampleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .black
        label.text = "Samle Label"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private var viewModel: TestViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: TestViewModel?) {
        super.init(nibName: nil, bundle: nil)
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: viewDidLoad 시 1회성 호출부
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpAction()
        bind()
    }
    
    // MARK: Components 간의 위치 설정
    private func setUpConstriants() {
        let safeArea = view.safeAreaLayoutGuide
        let spc = Constraints.shared
        
        [
            sampleButton,
            sampleLabel
        ].forEach {
            view.addSubview($0)
        }
        
        // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
        sampleButton.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading).offset(spc.space16)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-spc.space16)
            make.centerY.equalTo(safeArea.snp.centerY)
            make.height.equalTo(50)
        }
        
        sampleLabel.snp.makeConstraints { make in
            make.top.equalTo(sampleButton.snp.bottom).offset(spc.space16)
            make.leading.equalTo(sampleButton.snp.leading)
            make.trailing.equalTo(sampleButton.snp.trailing)
            make.height.equalTo(50)
        }
    }
    
    // MARK: 최상위 뷰의 Style 지정 (layer.cornerRadius etc) - Optional
    // 최상위 뷰를 제외한 나머지 UI Components는 각 Components 클로저 내부에서 Style 설정을 완료할 수 있게 만들기
    private func setUpStyle() {
        view.backgroundColor = .lightGray
    }
    
    // MARK: TabPulisher etc - Optional
    private func setUpAction() {
        sampleButton.tapPublisher
            .sink {
                print("Pressed!")
            }.store(in: &cancellables)
    }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() {
        viewModel?.$testTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedText in
                self?.sampleLabel.text = receivedText
            }.store(in: &cancellables)
    }
    
    // ETC 각각에 맞는 Method...
}

