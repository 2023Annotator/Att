//
//  AnalysisViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/04.
//

import UIKit

final class AnalysisViewController: UIViewController {

    // MARK: property 선언부
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
    
    private lazy var recordCountAnalysisView: TextContentView = {
        let view = TextContentView(title: "평균 작성 횟수", content: "평균 하루 3회 기록을 남깁니다.")
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
    
    // MARK: Init 선언부
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle 선언부
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure() {
        setUpConstriants()
        setUpMonthlyMoodCollectionView()
        setUpAction()
        bind()
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
            recordCountAnalysisView,
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
        
        recordCountAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(timeAnalysisView.snp.bottom).offset(constraints.space24)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(82)
        }
        
        monthlyMoodAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(recordCountAnalysisView.snp.bottom).offset(constraints.space40)
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

extension AnalysisViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        // data가 없으니 일단 하드코딩
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 35
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let sampleColors: [UIColor] = [.cherry, .blue, .yellow, .yellowGreen, .blue, .purple, .gray100] // TEST
            guard let cell = self.monthlyMoodAnalysisView.moodCollectionView.dequeueReusableCell(
                withReuseIdentifier: MonthlyMoodCollectionViewCell.identifier,
                for: indexPath) as? MonthlyMoodCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setUpBackgroundColor(bgColor: sampleColors[indexPath.row%7])
            
            return cell
        }
}
