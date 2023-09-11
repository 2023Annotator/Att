//
//  TodaysMoodView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

final class TodaysMoodView: RecordBrowseOuterTitleDefaultView {
    private lazy var moodColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 11.5
        view.clipsToBounds = true
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
        addSubview(moodColorView)
        moodColorView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(constraints.space20)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(132)
            make.height.equalTo(23)
        }
    }
    
    func setUpColor(color: UIColor) {
        moodColorView.backgroundColor = color
    }
}
