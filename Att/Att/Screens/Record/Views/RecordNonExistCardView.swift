//
//  DefaultCardView.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

final class RecordNonExistCardView: ATTCardView {

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 12
        view.distribution = .equalSpacing
        return view
    }()
    
    // TODO: 이미지 삽입
    private let ticketImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "ticket")
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let imageWithInset = image?.imageWithInset(insets: insets)
        view.image = imageWithInset
        view.layer.cornerRadius = 40
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let ticketCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    override init() {
        super.init()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(132)
        }
        
        [
            ticketImageView,
            ticketCaptionLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        ticketImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        ticketCaptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    override func setUpStyle() {
        super.setUpStyle()
        backgroundColor = .gray100
    }
    
    func setUpComponent(dateRelation: DateRelation) {
        ticketCaptionLabel.text = dateRelation.relationText
    }
}
