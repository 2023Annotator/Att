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
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        setUpConstriants()
        setUpStyle()
    }
    
    private func setUpConstriants() {
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpStyle() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.gray50.cgColor
    }
    
    // TODO: TEMPORARY parameter is Int -> Model
    func setUpComponent(date: Date) {
        let date = date.day()
        dayLabel.text = "\(date)"
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
