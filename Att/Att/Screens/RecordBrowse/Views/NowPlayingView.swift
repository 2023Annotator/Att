//
//  NowPlayingView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

final class NowPlayingView: RecordBrowseInnerTitleDefaultView {
    
    private let blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .regular)
        view.alpha = 0.8
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var musicImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "headphone")?
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
        view.image = image
        return view
    }()
    
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var thumbnailView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
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
        
        [
            blurEffectView,
            musicImageView,
            musicTitleLabel,
            thumbnailView
        ].forEach {
            addSubview($0)
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addSubview(titleLabel)
        
        musicImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(constraints.space16)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.height.equalTo(17)
        }
        
        musicTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(musicImageView.snp.trailing).offset(constraints.space4)
            make.trailing.equalTo(thumbnailView.snp.leading).offset(constraints.space4)
            make.centerY.equalTo(musicImageView)
            make.height.equalTo(22)
        }
        
        thumbnailView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(constraints.space20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(72)
        }
    }
    
    // TODO: Background Image Set
    func setUpComponent(musicInfo: MusicInfo?) {
        musicTitleLabel.text = musicInfo?.artistAndTitleStr()
        self.image = musicInfo?.thumbnailImage
        thumbnailView.image = musicInfo?.thumbnailImage
    }
}
