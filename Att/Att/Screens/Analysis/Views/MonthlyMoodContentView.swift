//
//  DailyMoodContentView.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class MonthlyMoodContentView: AnalysisDefaultView {

    lazy var moodCollectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: MonthlyMoodCollectionViewFlowLayout())
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    // TODO: Init 시 Mood 값 받아와서 갱신
    init() {
        super.init(title: "Mood Tracker")
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
        
        addSubview(moodCollectionView)
        
        let width = UIScreen.main.bounds.width
        let itemWidth = (width - Constraints.shared.space20 * 2) / 7
        let flooredItemWidth = floor(itemWidth)
        let viewWidth = flooredItemWidth * 7
        let viewHeight = flooredItemWidth * 5
        
        moodCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space16)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(viewWidth)
            make.height.equalTo(viewHeight)
        }
    }
    
    // TODO: Mood 구획 나누기
}
