//
//  ToTomorrowView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

final class ToTomorrowView: RecordBrowseOuterTitleDefaultView {

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    override init(title: String) {
        super.init(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        let constraints = Constraints.shared
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space12)
            make.leading.trailing.equalToSuperview().inset(constraints.space20) // TEST
            make.bottom.equalToSuperview()
        }
        contentLabel.sizeToFit()
    }
    
    func setUpComponent(text: String?) {
        contentLabel.text = text
    }
}
