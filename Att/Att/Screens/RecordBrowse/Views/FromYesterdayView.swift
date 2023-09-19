//
//  FromYesterdayView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

final class FromYesterdayView: RecordBrowseInnerTitleDefaultView {
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(title: String) {
        super.init(title: title)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        let constraints = Constraints.shared
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space4)
            make.leading.trailing.equalTo(titleLabel)
        }
        contentLabel.sizeToFit()
    }
    
    override func setUpStyle() {
        super.setUpStyle()
        backgroundColor = .gray100
    }
    
    func setUpComponent(text: String?) {
        contentLabel.text = text
    }
}
