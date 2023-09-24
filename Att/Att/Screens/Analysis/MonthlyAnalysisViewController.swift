//
//  AnalysisViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import Combine
import SnapKit
import UIKit

final class MonthlyMoodCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Int, Mood?> { }

final class MonthlyAnalysisViewController: UIViewController {

    private lazy var yearMonthLabel: UILabel = {
        let label = UILabel()
        label.font = .title3
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var timeAnalysisView: TextContentView = {
        let view = TextContentView(title: "주로 일기를 작성하는 시간")
        return view
    }()
    
    private lazy var monthlyMoodAnalysisView: MonthlyMoodContentView = {
        let view = MonthlyMoodContentView()
        return view
    }()
    
    private lazy var monthlyMoodSummaryAnalysisView: MoodSummaryContentView = {
        let view = MoodSummaryContentView()
        return view
    }()
    
    private lazy var mostPlayedMusicAnalysisView: MusicContentView = {
        let view = MusicContentView()
        return view
    }()
    
    private lazy var mostUsedWordAnalysisView: UsedWordContentView = {
        let view = UsedWordContentView()
        return view
    }()
    
    private var monthlyMoodCollectionViewDiffableDataSource: MonthlyMoodCollectionViewDiffableDataSource?
    private var analysisViewModel: AnalysisViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(analysisViewModel: AnalysisViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.analysisViewModel = analysisViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpMonthlyMoodCollectionView()
        bind()
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(yearMonthLabel)
        yearMonthLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(constraints.space16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(yearMonthLabel.snp.bottom).offset(constraints.space8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            make.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height)
        }
        
        [
            timeAnalysisView,
            monthlyMoodAnalysisView,
            monthlyMoodSummaryAnalysisView,
            mostPlayedMusicAnalysisView,
            mostUsedWordAnalysisView
        ].forEach {
            contentView.addSubview($0)
        }
        
        timeAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(constraints.space24)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(82)
        }
        
        monthlyMoodAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(timeAnalysisView.snp.bottom).offset(constraints.space42)
            make.leading.trailing.equalToSuperview()
        }
        
        monthlyMoodSummaryAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(monthlyMoodAnalysisView.snp.bottom).offset(constraints.space24)
            make.leading.trailing.equalToSuperview()
        }
        
        mostPlayedMusicAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(monthlyMoodSummaryAnalysisView.snp.bottom).offset(constraints.space24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(334)
        }
        
        mostUsedWordAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(mostPlayedMusicAnalysisView.snp.bottom).offset(constraints.space24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(238)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    private func setUpStyle() {
        view.backgroundColor = .black
    }
    
    private func setUpMonthlyMoodCollectionView() {
        monthlyMoodAnalysisView.moodCollectionView.dataSource = self
        monthlyMoodAnalysisView.moodCollectionView.delegate = self
        monthlyMoodAnalysisView.moodCollectionView.register(MonthlyMoodCollectionViewCell.self, forCellWithReuseIdentifier: MonthlyMoodCollectionViewCell.identifier)
    }
    
    private func bind() {
        analysisViewModel?.$currentMonthlyRecord
            .sink { [weak self] monthlyRecord in
                self?.setUpComponent(monthlyRecord: monthlyRecord)
            }.store(in: &cancellables)
    }
    
    private func setUpComponent(monthlyRecord: AttMonthlyRecord?) {
        setUpYearMonthLabelText(as: monthlyRecord?.yearAndMonth)
        timeAnalysisView.setUpComponent(as: monthlyRecord?.averageRecordTime)
        monthlyMoodSummaryAnalysisView.setUpComponent(moodFrequencyDictionary: monthlyRecord?.moodFrequencyDictionary)
        mostPlayedMusicAnalysisView.setUpComponent(mostPlayedMusicDictionary: monthlyRecord?.mostPlayedMusicInfoDictionary)
        mostUsedWordAnalysisView.setUpComponent(wordDictionary: monthlyRecord?.mostUsedWordDictionary)
    }
}

extension MonthlyAnalysisViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let moods = analysisViewModel?.getMoodList() else { return 0 }
        return moods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.monthlyMoodAnalysisView.moodCollectionView.dequeueReusableCell(
            withReuseIdentifier: MonthlyMoodCollectionViewCell.identifier,
            for: indexPath) as? MonthlyMoodCollectionViewCell,
              let moods = analysisViewModel?.getMoodList() else { return UICollectionViewCell() }
        cell.setUpBackgroundColor(bgColor: moods[indexPath.row]?.moodColor)
        
        return cell
    }
}

extension MonthlyAnalysisViewController {
    private func setUpYearMonthLabelText(as date: String?) {
        yearMonthLabel.text = date
    }
}
