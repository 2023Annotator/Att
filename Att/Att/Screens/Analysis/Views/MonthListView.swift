//
//  MonthListView.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import UIKit

final class MonthListView: AnalysisDefaultView {

    // MARK: property 선언부
    lazy var monthCollectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: MonthCollectionViewFlowLayout())
        return view
    }()
    
    // MARK: Init 선언부
    init() {
        super.init(title: "월간 분석")
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        let constraints = Constraints.shared
        
        addSubview(monthCollectionView)
        
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight = itemWidth * 0.22
        monthCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space28)
            make.leading.trailing.equalToSuperview()
            make.height.lessThanOrEqualTo(itemHeight * 12)
        }
    }
}
