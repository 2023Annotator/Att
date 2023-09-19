//
//  TicketDecorationView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

final class TicketDecorationView: UIView {

    private let leadingCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .black
        return view
    }()
    
    private let dottedLineView: DottedLineView = {
        let view = DottedLineView()
        return view
    }()
    
    private let trailingCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .black
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
        let constraints = Constraints.shared
        
        [
            leadingCircleView,
            trailingCircleView,
            dottedLineView
        ].forEach {
            addSubview($0)
        }
        
        leadingCircleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(-constraints.space16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        trailingCircleView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(-constraints.space16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        dottedLineView.snp.makeConstraints { make in
            make.leading.equalTo(leadingCircleView.snp.trailing).offset(constraints.space10)
            make.trailing.equalTo(trailingCircleView.snp.leading).offset(-constraints.space10)
            make.centerY.equalToSuperview()
            make.height.height.equalTo(32)
        }
    }
    
    func setUpLineColor(color: UIColor) {
        dottedLineView.setUpLineColor(color: color)
    }
}
