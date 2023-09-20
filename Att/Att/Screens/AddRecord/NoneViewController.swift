//
//  NoneViewController.swift
//  Att
//
//  Created by 정제인 on 2023/09/19.
//
import Combine
import CombineCocoa
import SnapKit
import UIKit

class NoneViewController: UIViewController {

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var sunButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellowGreen
        button.layer.cornerRadius = 20
        button.setTitle("눌러", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
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
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure() {
        setUpConstriants()
        setUpAction()
        bind()
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(contentView)
        
        view.addSubview(sunButton)
        sunButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalTo(view.safeAreaLayoutGuide.snp.center)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    private func setUpAction() {
        sunButton.tapPublisher
            .sink { [weak self] in
                let viewController = UINavigationController(rootViewController: AddColorViewController())
                viewController.modalPresentationStyle = .automatic
                self?.present(viewController, animated: true)
                
        }.store(in: &cancellables)
    }
    
    private func bind() { }
    
}
