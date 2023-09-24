//
//  MusicOfTheMonthView.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class MusicContentView: AnalysisDefaultView {

    private lazy var firstMusicFrameView: MusicFrameView = {
        let view = MusicFrameView()
        return view
    }()
    
    private lazy var secondMusicFrameView: MusicFrameView = {
        let view = MusicFrameView()
        return view
    }()
    
    private lazy var thirdMusicFrameView: MusicFrameView = {
        let view = MusicFrameView()
        return view
    }()

    init() {
        super.init(title: "Music of the Month")
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraints() {
        
        super.setUpConstraints()
        
        let constraints = Constraints.shared
        
        let musicFrameStackView = UIStackView()
        musicFrameStackView.axis = .vertical
        musicFrameStackView.alignment = .center
        musicFrameStackView.distribution = .equalSpacing
        
        [
            firstMusicFrameView,
            secondMusicFrameView,
            thirdMusicFrameView
        ].forEach {
            musicFrameStackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(96)
            }
        }
        
        addSubview(musicFrameStackView)
        musicFrameStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.space8)
            make.horizontalEdges.equalTo(titleLabel.snp.horizontalEdges)
            make.height.equalTo(304)
        }
        
    }
    
    func setUpComponent(mostPlayedMusicDictionary: [MusicInfo: Int]?) {
        guard let sortedPlayedMusicArr = mostPlayedMusicDictionary?.sorted(by: { $0.value > $1.value }) else { return }
        let views: [MusicFrameView] = [firstMusicFrameView, secondMusicFrameView, thirdMusicFrameView]
        for idx in 0..<sortedPlayedMusicArr.count {
            let info = sortedPlayedMusicArr[idx]
            views[idx].setUpComponent(playedFor: info.value, musicInfo: info.key)
        }
    }
    
}
