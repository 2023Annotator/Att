//
//  NowPlayingView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

final class NowPlayingView: RecordBrowseInnerTitleDefaultView {
    
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
        label.font = .smallCaption
        label.textAlignment = .left
        label.textColor = .white
        label.text = "종강 - 종강하고 싶어요"
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
            musicImageView,
            musicTitleLabel,
            thumbnailView
        ].forEach {
            addSubview($0)
        }
        
        musicImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(constraints.space16)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.height.equalTo(17)
        }
        
        musicTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(musicImageView.snp.trailing).offset(constraints.space4)
            make.centerY.equalTo(musicImageView)
            make.width.equalTo(108)
            make.height.equalTo(22)
        }
        
        thumbnailView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(constraints.space20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(72)
        }
    }
    
    // TODO: Background Image Set
    func setUpComponent(title: String, image: UIImage) {
        musicTitleLabel.text = title
        self.image = image
        backgroundColor = .black // TEST
        thumbnailView.backgroundColor = .white // TEST
    }
}
