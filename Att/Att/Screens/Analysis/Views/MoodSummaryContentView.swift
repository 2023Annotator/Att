//
//  MonthlyMoodContentView.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class MoodSummaryContentView: AnalysisDefaultView {

    private lazy var moodListView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue // TEST
        return view
    }()
    
    private lazy var primaryMoodLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var primaryColorView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var secondaryColorView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var thirdColorView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var fourthColorView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var fifthColorView: UIView = {
        let view = UIView()
        return view
    }()
    
    // TODO: Init 시 Mood 값 받아와서 갱신
    init() {
        super.init(title: "이달의 컬러")
        setUpConstraints()
        setUpComponent() // TODO
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        let constraints = Constraints.shared
        
        super.setUpConstraints()
        
        addSubview(moodListView)
        
        let width = UIScreen.main.bounds.width
        let itemWidth = (width - Constraints.shared.space20 * 2) / 8
        let flooredItemWidth = floor(itemWidth)
        
        let viewWidth = flooredItemWidth * 8
        let viewHeight = flooredItemWidth * 2
        
        moodListView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space16)
            make.leading.trailing.equalToSuperview().inset(constraints.space16)
            make.bottom.equalToSuperview()
            make.height.equalTo(viewHeight)
        }
        
        [
            primaryColorView,
            primaryMoodLabel,
            secondaryColorView,
            thirdColorView,
            fourthColorView,
            fifthColorView
        ].forEach {
            moodListView.addSubview($0)
        }
        
        primaryColorView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(moodListView.snp.centerX)
        }
        
        primaryMoodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraints.space8)
            make.leading.equalToSuperview().offset(constraints.space14)
            make.width.equalTo(64)
            make.height.equalTo(44)
        }
        
        secondaryColorView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(moodListView.snp.centerX)
            make.bottom.equalTo(moodListView.snp.centerY)
        }
        
        thirdColorView.snp.makeConstraints { make in
            make.top.equalTo(secondaryColorView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalTo(primaryColorView.snp.trailing)
            make.trailing.equalTo(secondaryColorView.snp.centerX)
        }
        
        fourthColorView.snp.makeConstraints { make in
            make.top.equalTo(secondaryColorView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalTo(thirdColorView.snp.trailing)
            make.width.equalTo(flooredItemWidth)
        }
        
        fifthColorView.snp.makeConstraints { make in
            make.top.equalTo(secondaryColorView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalTo(fourthColorView.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
    
    // TODO: Mood 구획 나누기
    func setUpComponent() {
        primaryColorView.backgroundColor = .yellow
        secondaryColorView.backgroundColor = .green
        thirdColorView.backgroundColor = .black
        fourthColorView.backgroundColor = .pink
        fifthColorView.backgroundColor = .purpleBlue
        
        primaryMoodLabel.text = "즐거움\n(총 12일)"
    }
}
