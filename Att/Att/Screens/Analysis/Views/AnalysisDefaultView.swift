//
//  AnalysisDefaultContentView.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import SnapKit
import UIKit

class AnalysisDefaultView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .title3
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    // MARK: Init 선언부
    init(title: String) {
        super.init(frame: CGRect.zero)
        setUpConstraints()
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
            make.height.equalTo(22)
        }
    }
    
    private func setUpTitle(as text: String) {
        titleLabel.text = text
    }
}
