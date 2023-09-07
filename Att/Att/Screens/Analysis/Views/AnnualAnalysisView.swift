//
//  AnnualAnalysisView.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import UIKit

class AnnualAnalysisView: AnalysisDefaultView {

    private lazy var analysisView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // TEST
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var viewNameLabel: UILabel = {
        let label = UILabel()
        label.font = .title0
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "ANNUAL\nANALYSIS"
        return label
    }()
    
    init() {
        super.init(title: "연간 분석")
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        let constraints = Constraints.shared
        
        [
            analysisView,
            viewNameLabel
        ].forEach {
            addSubview($0)
        }
        
        analysisView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space12)
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(128)
        }
        
        viewNameLabel.snp.makeConstraints {make in
            make.top.bottom.leading.trailing.equalTo(analysisView)
        }
    }
}
