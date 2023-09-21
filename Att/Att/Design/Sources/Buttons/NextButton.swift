//
//  NextButtonView.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//

import UIKit

final class NextButton: UIButton {
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        setUpComponent()
        setUpTitle(as: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpComponent() {
        titleLabel?.font = .subtitle3
        backgroundColor = .green
        setTitleColor(UIColor.black, for: .normal)
        layer.cornerRadius = 24
        clipsToBounds = true
    }
    
    private func setUpTitle(as text: String) {
        setTitle(text, for: .normal)
    }
}
