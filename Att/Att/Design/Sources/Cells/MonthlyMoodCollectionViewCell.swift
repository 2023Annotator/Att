//
//  MonthlyMoodCollectionViewCell.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class MonthlyMoodCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MonthlyMoodCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpBackgroundColor(bgColor: UIColor?) {
        if let bgColor = bgColor {
            backgroundColor = bgColor
        } else {
            backgroundColor = .gray100
        }
    }
}
