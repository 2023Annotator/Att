//
//  ATTCardView.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit

class ATTCardView: UIView {
    
    // MARK: Init 선언부
    init() {
        super.init(frame: CGRect.zero)
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpStyle() {
        layer.cornerRadius = 20
    }
}
