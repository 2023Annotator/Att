//
//  AnalysisListViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import Combine
import SnapKit
import UIKit

class AnalysisListViewController: UIViewController {
    
    private lazy var yearSelectorView: YearSelectorView = {
        let view = YearSelectorView()
        return view
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
    
    private lazy var monthListView: MonthListView = {
        let view = MonthListView()
        return view
    }()
    
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
            monthListView
        ].forEach {
            contentView.addSubview($0)
        }
        
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight = itemWidth * 0.22
        monthListView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(constraints.space28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(itemHeight * 9 + 50)
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
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let monthNameArr: [String] = [
            "JANUARY",
            "FEBRUARY",
            "MARCH",
            "APRIL",
            "MAY",
            "JUNE",
            "JULY",
            "AUGUST",
            "SEPTEMBER"
        ]
        
        let sampleColors: [UIColor] = [.cherry, .blue, .yellow, .yellowGreen, .blue, .purple, .gray100]
        
        guard let cell = self.monthListView.monthCollectionView.dequeueReusableCell(
            withReuseIdentifier: MonthCollectionViewCell.identifier,
            for: indexPath) as? MonthCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setUpCell(month: monthNameArr[indexPath.row], color: sampleColors[indexPath.row%7])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetVC = MonthlyAnalysisViewController(analysisViewModel: analysisViewModel)
        targetVC.modalPresentationStyle = .automatic
        self.present(targetVC, animated: true)
    }
}
