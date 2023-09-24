//
//  AnalysisListViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import Combine
import SnapKit
import UIKit

final class MonthListCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Int, MonthlyMoodRecord?> { }

final class AnalysisListViewController: UIViewController {
    
    private lazy var yearSelectorView: YearSelectorView = {
        let view = YearSelectorView(analysisViewModel: analysisViewModel)
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
    
    private var monthListCollectionDiffableDataSource: MonthListCollectionViewDiffableDataSource?
    
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
        setUpMonthCollectionViewDataSource()
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
        
        monthListView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(constraints.space28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setUpMonthCollectionView() {
        monthListView.monthCollectionView.delegate = self
        monthListView.monthCollectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: MonthCollectionViewCell.identifier)
    }
    
    private func setUpMonthCollectionViewDataSource() {
        let collectionView = monthListView.monthCollectionView
        collectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: MonthCollectionViewCell.identifier)
        collectionView.dataSource = monthListCollectionDiffableDataSource
        
        monthListCollectionDiffableDataSource = MonthListCollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, moodRecord) ->
            MonthCollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCollectionViewCell.identifier, for: indexPath) as? MonthCollectionViewCell else {
                return MonthCollectionViewCell()
            }
            
            cell.setUpComponent(monthlyMoodRecord: moodRecord)
            
            return cell
        }
    }
    
    private func performMonthCollectionViewCell(moodRecords: [MonthlyMoodRecord?]?) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MonthlyMoodRecord?>()
        snapshot.appendSections([0])
        if let moodRecords = moodRecords {
            snapshot.appendItems(moodRecords)
        }
        monthListCollectionDiffableDataSource?.apply(snapshot)
    }
    
    private func bind() {
        analysisViewModel?.$monthlyMoodRecords
            .sink { [weak self] moodRecords in
                self?.performMonthCollectionViewCell(moodRecords: moodRecords)
                self?.updateMonthListViewHeightConstraints(monthCount: moodRecords?.count)
            }.store(in: &cancellables)
    }
}

extension AnalysisListViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataCount = monthListCollectionDiffableDataSource?.accessibilityElementCount() {
            return dataCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if analysisViewModel?.isMonthlyRecordAccessible(indexPath: indexPath) == true {
            presentMonthlyAnalysisViewController(indexPath: indexPath)
        }
    }
}

extension AnalysisListViewController {
    private func updateMonthListViewHeightConstraints(monthCount: Int?) {
        guard let monthCount = monthCount else { return }
        
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight = itemWidth * 0.22
        let updatedHeight: CGFloat = itemHeight * CGFloat(monthCount) + 50
        monthListView.snp.updateConstraints { update in
            update.height.equalTo(updatedHeight)
        }
        
    }
    
    private func presentMonthlyAnalysisViewController(indexPath: IndexPath) {
        let month = indexPath.row + 1
        analysisViewModel?.updateMonthlyRecord(month: month)
        let targetVC = MonthlyAnalysisViewController(analysisViewModel: analysisViewModel)
        targetVC.modalPresentationStyle = .automatic
        present(targetVC, animated: true)
    }
}
