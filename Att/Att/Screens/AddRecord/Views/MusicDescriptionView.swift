//
//  MusicDescriptionView.swift
//  Att
//
//  Created by 황정현 on 2023/09/21.
//

import SnapKit
import UIKit

final class MusicDescriptionView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let constraints = Constraints.shared
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(constraints.space8)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
        
        [
            titleLabel,
            artistLabel
        ].forEach {
            stackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }
        
    }
    
    private func setUpStyle() {
        layer.cornerRadius = 20
        backgroundColor = .gray100
    }
    
    func setUpMusicInfo(title: String?, artist: String?) {
        titleLabel.text = title
        artistLabel.text = artist
    }
}
