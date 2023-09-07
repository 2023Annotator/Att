//
//  MonthCollectionViewCell.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MonthCollectionViewCell"
    
    private lazy var monthNameLabel: UILabel = {
        let label = UILabel()
        label.font = .title1
        label.textAlignment = .center
        label.textColor = .black
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
    
    private func setUpConstriants() {
        addSubview(monthNameLabel)
        monthNameLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpStyle() {
        layer.cornerRadius = 43
    }
    
    // TODO: Month 구조체를 통해 데이터를 갱신하는 형태로 변경
    func setUpCell(month: String, color: UIColor) {
        monthNameLabel.text = month
        backgroundColor = color
    }
}
