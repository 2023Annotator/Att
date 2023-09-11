//
//  AnalysisListViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import UIKit

class AnalysisListViewController: UIViewController {
    
    private lazy var yearSelectorView: YearSelectorView = {
        let view = YearSelectorView()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var annualView: AnnualAnalysisView = {
        let view = AnnualAnalysisView()
        return view
    }()
    
    private lazy var monthListView: MonthListView = {
        let view = MonthListView()
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
        
        // Do any additional setup after loading the view.
    }
    
    private func configure() {
        setUpConstriants()
        setUpMonthCollectionView()
        setUpAction()
        bind()
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(yearSelectorView)
        yearSelectorView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(54)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(yearSelectorView.snp.bottom).offset(constraints.space8)
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
            annualView,
            monthListView
        ].forEach {
            contentView.addSubview($0)
        }
        
        annualView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(constraints.space28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(162)
        }
        
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight = itemWidth * 0.22
        monthListView.snp.makeConstraints { make in
            make.top.equalTo(annualView.snp.bottom).offset(constraints.space42)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(itemHeight * 12 + 50) // TODO: item 갯수 받아와서 높이 작성
            make.bottom.equalToSuperview()
        }
    }
    
    private func setUpMonthCollectionView() {
        monthListView.monthCollectionView.dataSource = self
        monthListView.monthCollectionView.delegate = self
        monthListView.monthCollectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: MonthCollectionViewCell.identifier)
    }
    
    // MARK: TabPulisher etc - Optional
    private func setUpAction() { }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }
}

extension AnalysisListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TEST
        let monthNameArr: [String] = [
            "JANUARY",
            "FEBRUARY",
            "MARCH",
            "APRIL",
            "MAY",
            "JUNE",
            "JULY",
            "AUGUST",
            "SEPTEMBER",
            "OCTOBER",
            "NOVEMBER",
            "DECEMBER"
        ]
        
        let sampleColors: [UIColor] = [.cherry, .blue, .yellow, .yellowGreen, .blue, .purple, .gray100] // TEST
        
        guard let cell = self.monthListView.monthCollectionView.dequeueReusableCell(
            withReuseIdentifier: MonthCollectionViewCell.identifier,
            for: indexPath) as? MonthCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setUpCell(month: monthNameArr[indexPath.row], color: sampleColors[indexPath.row%7])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetVC = MonthlyAnalysisViewController()
        targetVC.modalPresentationStyle = .automatic
        self.present(targetVC, animated: true)
    }
}
