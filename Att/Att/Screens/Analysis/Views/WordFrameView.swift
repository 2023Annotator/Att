//
//  WordFrameView.swift
//  Att
//
//  Created by 황정현 on 2023/09/24.
//

import UIKit

final class WordFrameView: UIView {
    
    private lazy var usedRecordLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle3
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .title4
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        let constraints = Constraints.shared
        
        [
            usedRecordLabel,
            musicTitleLabel
        ].forEach {
            addSubview($0)
        }
        
        usedRecordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(constraints.space18)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalToSuperview()
        }
        
        musicTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(usedRecordLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(constraints.space18)
            make.centerY.equalTo(usedRecordLabel.snp.centerY)
            make.height.equalToSuperview()
        }
        
    }
    
    private func setUpStyle() {
        layer.cornerRadius = 12
        backgroundColor = .gray100
    }
    
    func setUpComponent(usedFor: Int, word: String) {
        usedRecordLabel.text = "\(usedFor) times"
        musicTitleLabel.text = word
    }
}
