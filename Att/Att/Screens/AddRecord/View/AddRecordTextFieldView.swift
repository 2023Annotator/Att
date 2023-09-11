//
//  AddRecordTextFieldView.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//

import UIKit

class AddRecordTextFieldView: UIView {
    
    private lazy var recordTextField: UITextView = {
        var textField = UITextView()
        
        textField.backgroundColor = .gray100
        textField.layer.cornerRadius = 10
        textField.textColor = .white
        textField.tintColor = .white  // textField를 눌렀을 때 흰색으로 살짝 변함
        textField.keyboardType = .default
        textField.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16);
        textField.becomeFirstResponder()
 
        return textField
    }()
        
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
        
    private func setUpConstraints() {
            
        let constraints = Constraints.shared
            
        addSubview(recordTextField)

        recordTextField.snp.makeConstraints { make in
            let height = UIScreen.main.bounds.width * 0.45
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(height)
        }
            
    }
}
