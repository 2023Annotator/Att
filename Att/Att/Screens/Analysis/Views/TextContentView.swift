//
//  TextContentView.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class TextContentView: AnalysisDefaultView {

    // MARK: property 선언부
    
    private lazy var contentLabelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    init(title: String, content: String) {
        super.init(title: title)
        setUpConstraints()
        setUpContentLabel(as: content)
        setUpCornerRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        
        super.setUpConstraints()
        
        let constraints = Constraints.shared
        
        [
            contentLabelBackgroundView,
            contentLabel
        ].forEach {
            addSubview($0)
        }
        addSubview(contentLabel)
        
        contentLabelBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space8)
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.bottom.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentLabelBackgroundView).inset(constraints.space16)
            make.leading.trailing.equalTo(contentLabelBackgroundView).inset(constraints.space26)
        }
    }
    
    private func setUpContentLabel(as text: String) {
        contentLabel.text = text
    }
    
    private func setUpCornerRadius() {
        contentLabelBackgroundView.layoutIfNeeded()
        contentLabelBackgroundView.layer.cornerRadius = contentLabelBackgroundView.bounds.width * 0.5
    }
}
