//
//  DefaultCardView.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

final class RecordNonExistCardView: ATTCardView {

    // MARK: property 선언부
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .title1
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .black
        label.text = "\(Date().year())\n\(Date().monthAndDay())" // TEST
        return label
    }()
    
    private lazy var dayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle1
        label.textAlignment = .center
        label.textColor = .black
        label.text = Date().weekday() // TEST
        return label
    }()
    
    private let ticketImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 40
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let ticketCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Click to add record"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    // MARK: Init 선언부
    override init() {
        super.init()
        setUpConstraints()
        setUpComponent() // TEST
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
    private func setUpConstraints() {
        let constraints = Constraints.shared
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(59)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(85)
        }
        
        addSubview(dayNameLabel)
        dayNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(constraints.space12) // ORGIN: 11
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
        
        addSubview(ticketImageView)
        ticketImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        addSubview(ticketCaptionLabel)
        ticketCaptionLabel.snp.makeConstraints { make in
            make.top.equalTo(ticketImageView.snp.bottom).offset(constraints.space8) // ORGIN: 11
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-42) // ORGIN: 42.94
            make.leading.equalToSuperview().offset(constraints.space22)
            make.trailing.equalToSuperview().offset(-constraints.space22)
            make.height.equalTo(100) // ORIGIN: 101
        }
    }
    
    override func setUpStyle() {
        super.setUpStyle()
        backgroundColor = .darkGray // TEMP
    }
    // TEST
    private func setUpComponent() {
        descriptionLabel.text = "당신의 기록 하나하나가 쌓여\n아름다운 일년을 만들어주고 어쩌고\n아무튼 감명깊고 유저에게 이 컨텐츠가\n모여서 대충 분석을 제공할 거란 노티"
    }
}
