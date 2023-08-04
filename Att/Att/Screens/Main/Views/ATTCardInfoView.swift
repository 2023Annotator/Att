//
//  ATTCardInfoView.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

final class ATTCardInfoView: UIView {

    // MARK: property 선언부
    private lazy var dayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .title3
        label.textAlignment = .left
        label.textColor = .black
        label.text = Date().weekday() // TEST
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .title3
        label.textAlignment = .right
        label.textColor = .black
        label.text = Date().date() // TEST
        return label
    }()
    
    private lazy var diaryInfoView: TitleDescriptionView = {
        let view = TitleDescriptionView(cardInfoType: .diary)
        return view
    }()
    
    private lazy var musicInfoView: TitleDescriptionView = {
        let view = TitleDescriptionView(cardInfoType: .music)
        return view
    }()
    
    // MARK: Init 선언부
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
    private func setUpConstraints() {
        let constraints = Constraints.shared
        
        addSubview(dayNameLabel)
        dayNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.width.equalTo(60)
            make.height.equalTo(23)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.width.equalTo(180)
            make.height.equalTo(23)
        }
        
        addSubview(diaryInfoView)
        diaryInfoView.snp.makeConstraints { make in
            make.top.equalTo(dayNameLabel.snp.bottom).offset(constraints.space12)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(40)
        }
        
        addSubview(musicInfoView)
        musicInfoView.snp.makeConstraints { make in
            make.top.equalTo(diaryInfoView.snp.bottom).offset(constraints.space12)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(40)
        }
    }
}
