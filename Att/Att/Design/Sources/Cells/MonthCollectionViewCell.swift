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
        addSubview(monthNameLabel)
        monthNameLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpStyle() {
        layer.cornerRadius = 43
        backgroundColor = .gray100
    }
    
    func setUpComponent(monthlyMoodRecord: MonthlyMoodRecord?) {
        monthNameLabel.text = monthlyMoodRecord?.month
        if let color = monthlyMoodRecord?.mood?.moodColor {
            backgroundColor = color
        }
    }
}
