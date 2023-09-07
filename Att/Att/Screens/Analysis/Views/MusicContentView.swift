//
//  MusicOfTheMonthView.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class MusicContentView: AnalysisDefaultView {

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3) // TEST
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    private lazy var listenRecordLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle3
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var headphoneImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "headphone")
        return view
    }()
    
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = .blue // TEST
        return view
    }()

    // TODO: Init 시 Music Info ViewModel로부터 받아와 ContentView를 갱신
    init() {
        super.init(title: "Music of the Month")
        setUpConstraints()
        setUpStyle()
        test() // TEST
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        
        super.setUpConstraints()
        
        let constraints = Constraints.shared
        
        addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space8)
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.bottom.equalToSuperview()
        }
        
        [
            listenRecordLabel,
            headphoneImageView,
            musicTitleLabel,
            thumbnailImageView
        ].forEach {
            contentView.addSubview($0)
        }
        
        listenRecordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraints.space12)
            make.leading.equalToSuperview().offset(constraints.space18)
            make.trailing.equalTo(thumbnailImageView.snp.leading).offset(-constraints.space18)
            make.height.equalTo(22)
        }
        
        headphoneImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-constraints.space12)
            make.leading.equalToSuperview().offset(constraints.space18)
            make.width.height.equalTo(23)
        }
        
        musicTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(headphoneImageView.snp.trailing).offset(constraints.space8)
            make.trailing.equalTo(thumbnailImageView.snp.leading).offset(-constraints.space18)
            make.centerY.equalTo(headphoneImageView.snp.centerY)
            make.height.equalTo(22)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(constraints.space20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
    }
    
    private func setUpStyle() {
        layer.cornerRadius = 12
    }
    
    // TEST
    private func test() {
        
        listenRecordLabel.text = "17회 기록"
        musicTitleLabel.text = "???? - ?????"
    }
    
    // TODO: Music Info ViewModel로부터 받아와 ContentView를 갱신하는 메소드

}
