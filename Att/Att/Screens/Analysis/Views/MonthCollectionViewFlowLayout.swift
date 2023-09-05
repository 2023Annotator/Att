//
//  MonthCollectionViewFlowLayout.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import UIKit

final class MonthCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        scrollDirection = .horizontal
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight = itemWidth * 0.22
        itemSize = CGSize(width: itemWidth, height: itemHeight)
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
