//
//  NextButtonView.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//

import UIKit

class NextButtonView: UIButton {

    private lazy var nextButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .subtitle3
        button.backgroundColor = .green
        button.setTitleColor(UIColor.black, for: .normal) 
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.isEnabled = false       // 버튼의 동작 설정 (처음에는 동작 off)
        return button
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
        
        addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(48)
        }
        
    }
}
