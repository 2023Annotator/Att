//
//  MostUsedWordContentView.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class UsedWordContentView: AnalysisDefaultView {

    private lazy var firstUsedWordFrameView: WordFrameView = {
        let view = WordFrameView()
        return view
    }()
    
    private lazy var secondUsedWordFrameView: WordFrameView = {
        let view = WordFrameView()
        return view
    }()
    
    private lazy var thirdUsedWordFrameView: WordFrameView = {
        let view = WordFrameView()
        return view
    }()
    
    init() {
        super.init(title: "가장 많이 사용한 단어")
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        let constraints = Constraints.shared
        
        super.setUpConstraints()
        
        let usedWordFrameStackView = UIStackView()
        usedWordFrameStackView.axis = .vertical
        usedWordFrameStackView.alignment = .center
        usedWordFrameStackView.distribution = .equalSpacing
        
        [
            firstUsedWordFrameView,
            secondUsedWordFrameView,
            thirdUsedWordFrameView
        ].forEach {
            usedWordFrameStackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(64)
            }
        }
        
        addSubview(usedWordFrameStackView)
        usedWordFrameStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space8)
            make.horizontalEdges.equalTo(titleLabel.snp.horizontalEdges)
            make.height.equalTo(208)
        }
    }
    
    func setUpComponent(wordDictionary: [String: Int]?) {
        guard let sortedUsedWordArr = wordDictionary?.sorted(by: { $0.value > $1.value }) else { return }
        let views: [WordFrameView] = [firstUsedWordFrameView, secondUsedWordFrameView, thirdUsedWordFrameView]
        for idx in 0..<sortedUsedWordArr.count {
            let info = sortedUsedWordArr[idx]
            views[idx].setUpComponent(usedFor: info.value, word: info.key)
        }
    }
}
