//
//  AddMusicButton.swift
//  Att
//
//  Created by 정제인 on 2023/09/11.
//

import UIKit

class AddMusicButtonView: UIButton {

    var addMusicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 20
//        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.textColor = .green
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        addSubview(addMusicButton)
        addMusicButton.addSubview(mainLabel)
        
        addMusicButton.widthAnchor.constraint(equalToConstant: 258).isActive = true
        addMusicButton.heightAnchor.constraint(equalToConstant: 258).isActive = true
        
        addMusicButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            
        }
        
        
        
    }
}
