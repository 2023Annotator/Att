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

    // 이제부터 여기가 루트~
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var sunButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellowGreen
        button.layer.cornerRadius = 20
        button.setTitle("눌러", for : .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    
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
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.center.equalTo(view.safeAreaLayoutGuide.snp.center)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    private func setUpAction() {
        sunButton.tapPublisher
            .sink { [weak self] in
                let vc = UINavigationController(rootViewController: AddColorViewController())
                vc.modalPresentationStyle = .automatic
                self?.present(vc, animated: true)
                
        }.store(in: &cancellables)
        
        
    }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }
    
}
