//
//  ATTWeekdayCollectionViewCell.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit

class ATTWeekdayCollectionViewCell: UICollectionViewCell {
    
    // MARK: property 선언부
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        return label
    }()
    
    private lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        return label
    }()
    
    // MARK: Init 선언부
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure() {
        setUpConstriants()
        setUpStyle()
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraints.space8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }
        
        addSubview(weekdayLabel)
        weekdayLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(constraints.space10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }
    }
    
    // MARK: 최상위 뷰의 Style 지정 (layer.cornerRadius etc) - Optional
    // 최상위 뷰를 제외한 나머지 UI Components는 각 Components 클로저 내부에서 Style 설정을 완료할 수 있게 만들기
    private func setUpStyle() {
        layer.cornerRadius = 8
    }
}
