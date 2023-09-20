//
//  NextButtonView.swift
//  Att
//
//  Created by 정제인 on 2023/09/08.
//

import UIKit

final class NextButtonView: UIButton {
    
    private lazy var nextButton: UIButton = {
        var button = UIButton(type: .custom)
        button.titleLabel?.font = .subtitle3
        button.backgroundColor = .green
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        setUpTitle(as: title)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let constraints = Constraints.shared
        
        addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(48)
        }
    }
    
    private func setUpTitle(as text: String) {
        nextButton.setTitle(text, for: .normal)
    }
}
