//
//  ATTFromYesterdayView.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit

final class ATTFromYesterdayView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .left
        label.textColor = .black
        label.text = CardInfoType.fromYesterday.name
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
        setUpStyle()
        setUpComponent() // TEST
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let constraints = Constraints.shared
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraints.space8)
            make.leading.equalToSuperview().offset(constraints.space16)
            make.trailing.equalToSuperview().offset(-constraints.space16)
            make.height.equalTo(19)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space4)
            make.leading.trailing.equalTo(titleLabel)
        }
        descriptionLabel.sizeToFit()
    }
    
    private func setUpStyle() {
        layer.cornerRadius = 10
        backgroundColor = .white
    }
    // TEST
    private func setUpComponent() {
        descriptionLabel.text = "크하하하! 크하하하! 크하하하!"
    }
}
