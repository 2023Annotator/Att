//
//  YearSelectorView.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import UIKit

final class YearSelectorView: UIView {

    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = .title3
        label.textAlignment = .center
        label.textColor = .white
        label.text = "2023" // TEST
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.left")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.right")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let constraints = Constraints.shared
        
        [
            yearLabel,
            leftButton,
            rightButton
        ].forEach {
            addSubview($0)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(constraints.space42)
        }
        
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    private func setUpStyle() {
        backgroundColor = .clear
    }
}
