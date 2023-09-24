//
//  MonthlyMoodCollectionViewFlowLayout.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class MonthlyMoodCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        scrollDirection = .vertical
        let width = UIScreen.main.bounds.width
        let itemWidth = (width - Constraints.shared.space20 * 2) / 7
        let flooredItemWidth = floor(itemWidth)
        itemSize = CGSize(width: flooredItemWidth, height: flooredItemWidth)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        super.prepare()
    }
}
