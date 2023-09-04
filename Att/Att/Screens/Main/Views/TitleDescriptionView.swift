//
//  ATTCardInfoView.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

// MARK: View Height = titleLabel.height + descriptionLabel.height = 22 + 18 = 40
final class TitleDescriptionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle3
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    // Only CardInfoType.music에서 사용
    private lazy var musicImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "headphone")
        return view
    }()
    
    init(cardInfoType: CardInfoType) {
        super.init(frame: CGRect.zero)
        setUpConstraints(cardInfoType: cardInfoType)
        setUpTitle(cardInfoType: cardInfoType)
        setUpDescription(cardInfotype: cardInfoType) // TEST
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints(cardInfoType: CardInfoType) {
        let constraints = Constraints.shared
        
        [
            titleLabel,
            descriptionLabel
        ].forEach {
            addSubview($0)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(22)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(18)
        }
        
        switch cardInfoType {
        case .diary:
            descriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(self.snp.leading)
            }
        case .music:
            addSubview(musicImageView)
            musicImageView.snp.makeConstraints { make in
                make.leading.equalTo(titleLabel.snp.leading)
                make.width.height.equalTo(17)
                make.centerY.equalTo(descriptionLabel.snp.centerY)
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(musicImageView.snp.trailing).offset(constraints.space4)
            }
        default: break
        }
    }
    
    private func setUpTitle(cardInfoType: CardInfoType) {
        titleLabel.text = cardInfoType.name
    }
    
    // TEST
    private func setUpDescription(cardInfotype: CardInfoType) {
        switch cardInfotype {
        case .diary:
            descriptionLabel.text = "Something Something Some"
        case .music:
            return descriptionLabel.text = "---------"
        default: break
        }
    }
}
