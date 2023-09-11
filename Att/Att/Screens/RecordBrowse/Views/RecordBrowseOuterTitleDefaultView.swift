//
//  RecordBrowseDefaultView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

class RecordBrowseOuterTitleDefaultView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .smallTitle
        label.textAlignment = .left
        label.textColor = .black
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
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(28)
        }
    }
    
    private func setUpStyle() {
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    private func setUpTitle(as text: String) {
        titleLabel.text = text
    }
}
