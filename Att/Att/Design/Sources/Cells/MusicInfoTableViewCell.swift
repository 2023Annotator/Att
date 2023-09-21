//
//  MusicInfoTableViewCell.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import UIKit

final class MusicInfoTableViewCell: UITableViewCell {
    
    static let identifier = "MusicInfoTableViewCell"
    
    private lazy var thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private var musicInfo: MusicInfo?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpConstraints() {
        let constraints = Constraints.shared
        
        addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(constraints.space20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        let textInfoStackView = UIStackView()
        textInfoStackView.spacing = 8
        textInfoStackView.axis = .vertical
        textInfoStackView.distribution = .equalSpacing
        
        addSubview(textInfoStackView)
        textInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(constraints.space16)
            make.trailing.equalToSuperview().inset(constraints.space16)
            make.centerY.equalTo(thumbnailImageView.snp.centerY)
        }
        
        [
            titleLabel,
            artistLabel
        ].forEach {
            textInfoStackView.addArrangedSubview($0)
        }
    }
    
    func setUpComponent(info: MusicInfo?) {
        musicInfo = info
        thumbnailImageView.image = musicInfo?.thumbnailImage
        titleLabel.text = musicInfo?.title
        artistLabel.text = musicInfo?.artist
    }
    
    func getMusicInfo() -> MusicInfo? {
        return musicInfo
    }
}
