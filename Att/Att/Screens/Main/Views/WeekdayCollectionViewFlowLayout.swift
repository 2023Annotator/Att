//
//  WeekdayCollectionViewFlowLayout.swift
//  Att
//
//  Created by 황정현 on 2023/08/16.
//

import UIKit

final class WeekdayCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        itemSize = ComponentsSet.set.weekdayCellSize
        minimumLineSpacing = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { fatalError() }
        let visibleCellNum: CGFloat = 7
        let itemArea = (itemSize.width * visibleCellNum) + (minimumLineSpacing * (visibleCellNum - 1))
        let horizontalInsets = (collectionView.frame.width - itemArea) / 2
        sectionInset = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)
    }
}
