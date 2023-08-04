//
//  MainViewController.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {

    // MARK: property 선언부
    
    private lazy var fromYesterdayView: ATTFromYesterdayView = {
        let view = ATTFromYesterdayView()
        return view
    }()
    
    private lazy var cardView: ATTCardView = {
        let view = ATTCardView()
        return view
    }()
    
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
    }

    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpAction()
        bind()
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(fromYesterdayView)
        fromYesterdayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(constraints.space16)// TEMP
            make.leading.equalToSuperview().offset(constraints.space16)
            make.trailing.equalToSuperview().offset(-constraints.space16)
            make.height.equalTo(100)
        }
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(508)
        }
    }
    
    // MARK: 최상위 뷰의 Style 지정 (layer.cornerRadius etc) - Optional
    // 최상위 뷰를 제외한 나머지 UI Components는 각 Components 클로저 내부에서 Style 설정을 완료할 수 있게 만들기
    private func setUpStyle() { }
    
    // MARK: TabPulisher etc - Optional
    private func setUpAction() { }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }
}
