//
//  DiaryView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

final class DiaryView: RecordBrowseOuterTitleDefaultView {

    private lazy var contentView: UITextView = {
        let view = UITextView()
        view.font = .caption2
        view.textAlignment = .left
        view.textColor = .white
        view.layer.cornerRadius = 12
        view.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return view
    }()
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        let constraints = Constraints.shared
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space22)
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.bottom.equalToSuperview()
        }
        contentView.sizeToFit()
    }
    
    func setUpComponent(color: UIColor, content: String) {
        contentView.backgroundColor = color
        contentView.text = content
    }
    
}
