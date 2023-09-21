//
//  AddRecordTextFieldView.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//

import UIKit

final class AddRecordTextView: UITextView {
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        setUpComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpComponent() {
        backgroundColor = .gray100
        layer.cornerRadius = 10
        textColor = .white
        font = .caption1
        keyboardType = .default
        textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
