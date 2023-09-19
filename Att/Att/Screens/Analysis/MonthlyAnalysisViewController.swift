//
//  AnalysisViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class MonthlyAnalysisViewController: UIViewController {

    private lazy var yearMonthLabel: UILabel = {
        let label = UILabel()
        label.font = .title3
        label.textAlignment = .center
        label.textColor = .white
        label.text = "2023.04" // TEST
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
        let view = TextContentView(title: "주로 일기를 작성하는 시간", content: "00님은 보통 새벽 2-3시 사이에 일기를 작성하는 편입니다.")
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
    
    private lazy var musicAnalysisView: MusicContentView = {
        let view = MusicContentView()
        return view
    }()
    
    private lazy var mostUsedWordAnalysisView: MostUsedWordContentView = {
        let view = MostUsedWordContentView()
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpMonthlyMoodCollectionView()
        setUpAction()
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
            musicAnalysisView,
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
        
        musicAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(monthlyMoodSummaryAnalysisView.snp.bottom).offset(constraints.space24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(126)
        }
        
        mostUsedWordAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(musicAnalysisView.snp.bottom).offset(constraints.space36)
            make.leading.trailing.equalToSuperview()
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
    
    // MARK: TabPulisher etc - Optional
    private func setUpAction() { }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }
}

extension MonthlyAnalysisViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sampleColors: [UIColor] = [.cherry, .blue, .yellow, .yellowGreen, .blue, .purple, .gray100]
        guard let cell = self.monthlyMoodAnalysisView.moodCollectionView.dequeueReusableCell(
            withReuseIdentifier: MonthlyMoodCollectionViewCell.identifier,
            for: indexPath) as? MonthlyMoodCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setUpBackgroundColor(bgColor: sampleColors[indexPath.row%7])
        
        return cell
    }
}

extension MonthlyAnalysisViewController {
    private func setUpYearMonthLabelText(as date: String) {
        yearMonthLabel.text = date
    }
}
