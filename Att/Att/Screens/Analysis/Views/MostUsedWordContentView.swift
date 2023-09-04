//
//  MostUsedWordContentView.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class MostUsedWordContentView: AnalysisDefaultView {

    // MARK: property 선언부
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .green // TEST
        return view
    }()
    
    // TODO: Init 시 Mood 값 받아와서 갱신
    init() {
        super.init(title: "가장 많이 사용한 단어")
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
    override func setUpConstraints() {
        let constraints = Constraints.shared
        
        super.setUpConstraints()
        
        addSubview(contentView)
        
        let viewWidth = UIScreen.main.bounds.width - constraints.space16 * 2
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space16)
            make.leading.trailing.equalToSuperview().inset(constraints.space16)
            make.bottom.equalToSuperview()
            make.height.equalTo(viewWidth)
        }
    }
    
    // TODO: Mood 구획 나누기
}
