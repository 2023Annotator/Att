//
//  MusicFrameView.swift
//  Att
//
//  Created by 황정현 on 2023/09/24.
//

import UIKit

final class MusicFrameView: UIImageView {
    
    private let blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .regular)
        view.alpha = 0.8
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
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
        view.image = UIImage(named: "headphone")?
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
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
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        let constraints = Constraints.shared
        
        [
            blurEffectView,
            contentView
        ].forEach {
            addSubview($0)
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraints.space8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(blurEffectView.snp.edges)
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
    
    func setUpComponent(playedFor: Int, musicInfo: MusicInfo) {
        listenRecordLabel.text = "\(playedFor)회 기록"
        musicTitleLabel.text = musicInfo.artistAndTitleStr()
        self.image = musicInfo.thumbnailImage
        thumbnailImageView.image = musicInfo.thumbnailImage
    }
}
