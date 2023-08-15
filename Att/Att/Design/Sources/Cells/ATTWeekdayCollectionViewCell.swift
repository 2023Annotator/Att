//
//  ATTWeekdayCollectionViewCell.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit

enum CellStatus {
    case selected
    case deselected
}

class ATTWeekdayCollectionViewCell: UICollectionViewCell {
    static let identifier = "ATTWeekdayCollectionViewCell"
    
    // MARK: property 선언부
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .center
        label.textColor = .white
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
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: 최상위 뷰의 Style 지정 (layer.cornerRadius etc) - Optional
    // 최상위 뷰를 제외한 나머지 UI Components는 각 Components 클로저 내부에서 Style 설정을 완료할 수 있게 만들기
    private func setUpStyle() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.gray50.cgColor
    }
    
    // TEMPORARY parameter is Int -> Model
    func setUpComponent(data: Int) {
        dayLabel.text = "\(data)"
    }
    
    func updateSelectedCellDesign(status: CellStatus) {
        switch status {
        case .selected:
            backgroundColor = .gray100
            layer.borderWidth = 2
        case .deselected:
            backgroundColor = .black
            layer.borderWidth = 0
        }
    }
}
