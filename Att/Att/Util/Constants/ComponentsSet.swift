//
//  ComponentsSet.swift
//  Att
//
//  Created by 황정현 on 2023/08/16.
//

import Foundation
import UIKit.UIScreen

struct ComponentsSet {
    static let set = ComponentsSet()
    
//    CGSize(width: 44, height: 56)
    let weekdayCellSize: CGSize = {
        let width = UIScreen.main.bounds.width
        let cellWidth: CGFloat = width * 0.11
        let cellHeight: CGFloat = cellWidth * 1.27
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }()
    
    // 12
    let weekdayCellSpacing: CGFloat = {
        let width = UIScreen.main.bounds.width
        let cellWidth: CGFloat = width * 0.11
        let cellSpacing = (width - cellWidth * 7) / 8
        return cellSpacing
    }()
}
