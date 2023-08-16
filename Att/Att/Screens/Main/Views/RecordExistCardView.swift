//
//  ATTCardView.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

final class RecordExistCardView: ATTCardView {

    // MARK: property 선언부
    private lazy var musicThumbnailView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white // TEST
        return view
    }()
    
    private lazy var cardInfoview: ATTCardInfoView = {
        let view = ATTCardInfoView()
        return view
    }()
    
    // MARK: Init 선언부
    override init() {
        super.init()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
    private func setUpConstraints() {
        let constraints = Constraints.shared
        
        addSubview(musicThumbnailView)
        musicThumbnailView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(self.snp.width)
        }
        
        addSubview(cardInfoview)
        cardInfoview.snp.makeConstraints { make in
            make.top.equalTo(musicThumbnailView.snp.bottom).offset(constraints.space20)
            make.bottom.equalToSuperview().offset(-constraints.space20)
            make.leading.equalToSuperview().offset(constraints.space22)
            make.trailing.equalToSuperview().offset(-constraints.space22)
        }
    }
    
    // TODO: 일간 Data 기반 Initialize
    override func setUpStyle() {
        super.setUpStyle()
        backgroundColor = .yellow // TEST
    }
}
