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
        let height = UIScreen.main.bounds.height
        let itemHeight = height * 0.066
        let itemWidth = itemHeight * 0.79
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumLineSpacing = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { fatalError() }
        let visibleCellNum: CGFloat = 7
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let itemArea = (itemSize.width * visibleCellNum) + (minimumLineSpacing * (visibleCellNum - 1))
        let horizontalInsets = (collectionView.frame.width - itemArea) / 2
        sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        super.prepare()
    }
}
