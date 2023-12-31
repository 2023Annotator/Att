//
//  RecordBrowseInnerTitleDefaultView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

class RecordBrowseInnerTitleDefaultView: UIImageView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .title4
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        setUpConstraints()
        setUpStyle()
        setUpTitle(as: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        let constraints = Constraints.shared
        
        [
            titleLabel
        ].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraints.space12)
            make.leading.equalToSuperview().offset(constraints.space20)
            make.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(26)
        }
    }
    
    func setUpStyle() {
        layer.cornerRadius = 12
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    private func setUpTitle(as text: String) {
        titleLabel.text = text
    }
}
