//
//  AddRecordTextFieldView.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//

import UIKit

class AddRecordTextFieldView: UIView {

    private lazy var addRecordTextFieldView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray100 // TEST
            view.layer.cornerRadius = 15
        
            view.addSubview(recordTextField)
            view.addSubview(addRecordTextFieldLabel)
        
            return view
        }()
        
        private lazy var addRecordTextFieldLabel: UILabel = {
            let label = UILabel()
            label.font = .caption1
            label.textAlignment = .center
            label.textColor = .gray50
            label.numberOfLines = 2
            label.text = "입력해주세요"
            return label
        }()
        
        private lazy var recordTextField: UITextField = {
            var textField = UITextField()
            textField.frame.size.height = 128    // textField의 높이 설정
            textField.backgroundColor = .gray100
            textField.borderStyle = .roundedRect
            textField.textColor = .gray50
            textField.tintColor = .white  // textField를 눌렀을 때 흰색으로 살짝 변함
            textField.autocorrectionType = .no        // 틀린 글자가 있는 경우 자동으로 교정 (해당 기능은 off)
            textField.spellCheckingType = .no         // 스펠링 체크 기능 (해당 기능은 off)
            textField.keyboardType = .default
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
            
            //super.setUpConstraints()
            
            let constraints = Constraints.shared
            
            [
                addRecordTextFieldView,
                recordTextField,
                addRecordTextFieldLabel
            ].forEach {
                addSubview($0)
            }
            
            addRecordTextFieldView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(constraints.space20)
                make.height.equalTo(128)
            }
            
            recordTextField.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(constraints.space20)
                make.height.equalTo(128)
            }
            
            addRecordTextFieldLabel.snp.makeConstraints {make in
                make.top.bottom.leading.trailing.equalTo(addRecordTextFieldView)
            }
        }
    }
}
