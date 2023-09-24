//
//  MainViewController.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import Combine
import CombineCocoa
import UIKit
import SnapKit

final class RecordCardCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Int, AttDailyRecord?> { }
final class WeekdayCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Int, Date> { }

final class RecordViewController: UIViewController {
    private lazy var fromYesterdayView: ATTFromYesterdayView = {
        let view = ATTFromYesterdayView()
        return view
    }()
    
    private lazy var cardCollectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: CardCollectionViewFlowLayout())
        view.isScrollEnabled = true
        view.contentInsetAdjustmentBehavior = .always
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = .clear
        return view
    }()
    
    private var cardCollectionDiffableDataSource: RecordCardCollectionViewDiffableDataSource!
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 7
        pageControl.pageIndicatorTintColor = .gray100
        pageControl.currentPageIndicatorTintColor = .green
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private lazy var weekdayCollectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: WeekdayCollectionViewFlowLayout())
        view.isScrollEnabled = true
        view.isPagingEnabled = true
        view.contentInsetAdjustmentBehavior = .always
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        return view
    }()
    
    private var weekdayCollectionDiffableDataSource: WeekdayCollectionViewDiffableDataSource!
    
    private var weekdayVisibilityViewModel: WeekdayVisiblityViewModel?
    private var dailyRecordViewModel: DailyRecordViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private var isScrolling = true
    
    init(weekdayVisibilityViewModel: WeekdayVisiblityViewModel, dailyRecordViewModel: DailyRecordViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.weekdayVisibilityViewModel = weekdayVisibilityViewModel
        self.dailyRecordViewModel = dailyRecordViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dailyRecordViewModel?.updateRecordsWhenViewWillAppear()
    }
    
    private func configure() {
        setUpConstriants()
        setUpDelegate()
        setUpCollectionViewDataSource()
        setUpAction()
        bind()
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(fromYesterdayView)
        fromYesterdayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(54)
            make.leading.equalToSuperview().offset(constraints.space20)
            make.trailing.equalToSuperview().offset(-constraints.space20)
            make.height.equalTo(61)
        }
        
        let width = UIScreen.main.bounds.width
        let viewMargin: CGFloat = 20
        let itemWidth = width - viewMargin * 2
        let viewHeight = itemWidth * 1.62
        view.addSubview(cardCollectionView)
        cardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(fromYesterdayView.snp.bottom).offset(constraints.space12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(viewHeight)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(cardCollectionView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(12)
        }
        
        view.addSubview(weekdayCollectionView)
        weekdayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(constraints.space16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
    }
    
    private func setUpDelegate() {
        cardCollectionView.delegate = self
        weekdayCollectionView.delegate = self
    }
    
    private func setUpCollectionViewDataSource() {
        setUpCardCollectionViewDataSource()
        setUpWeekdayCollectionViewDataSource()
    }
    
    private func setUpAction() {
        let upSwipeGesture = UISwipeGestureRecognizer(target: nil, action: nil)
        upSwipeGesture.direction = .up
        let downSwipeGesture = UISwipeGestureRecognizer(target: nil, action: nil)
        downSwipeGesture.direction = .down
        
        [
            upSwipeGesture,
            downSwipeGesture
        ].forEach {
            view.addGestureRecognizer($0)
        }
        
        let input = WeekdayVisiblityViewModel.Input(
            upSwipePublisher: upSwipeGesture.swipePublisher,
            downSwipePublisher: downSwipeGesture.swipePublisher
        )
        
        _ = weekdayVisibilityViewModel?.transform(input: input)
        
        weekdayVisibilityViewModel?.$weekdayVisibleStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.weekdayCollectionViewVisible(as: status)
                self?.fromYesterdayViewVisible(as: status)
                
                if status == true {
                    self?.scrollToInitialPosition()
                }
            }.store(in: &cancellables)
    }
    
    private func bind() {
        bindCalendarView()
        bindCollectionViewIndexPath()
        bindRecord()
    }
}

// MARK: Binding
extension RecordViewController {
    private func bindCalendarView() {
        dailyRecordViewModel?.$isCalendarViewDismissed
            .sink { [weak self] isDismissed in
                if isDismissed {
                    self?.isScrolling = false
                    self?.scrollToInitialPosition()
                }
            }.store(in: &cancellables)
    }
    
    private func bindCollectionViewIndexPath() {
        dailyRecordViewModel?.$selectedDateIndexPath
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let weekdayCollectionView = self?.weekdayCollectionView else { return }
                for cell in weekdayCollectionView.visibleCells {
                    guard let cell = cell as? ATTWeekdayCollectionViewCell else { return }
                    if weekdayCollectionView.cellForItem(at: indexPath) == cell {
                        cell.updateSelectedCellDesign(status: .selected)
                    } else {
                        cell.updateSelectedCellDesign(status: .deselected)
                    }
                }
                
                let currentIndexPath = IndexPath(row: indexPath.row % 7, section: 0)
                guard let dateViewModel = self?.dailyRecordViewModel else { return }
                dateViewModel.updateSelectedCardIndexPath(as: currentIndexPath)
            }.store(in: &cancellables)
        
        dailyRecordViewModel?.$selectedCardIndexPath
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let cardCollectionView = self?.cardCollectionView else { return }
                for cell in cardCollectionView.visibleCells {
                    guard let cell = cell as? RecordCardCollectionViewCell else { return }
                    
                    if cardCollectionView.cellForItem(at: indexPath) == cell {
                        cell.blurEffect(isHidden: true)
                    } else {
                        cell.blurEffect(isHidden: false)
                    }
                }
                
                self?.pageControl.currentPage = indexPath.row
            }.store(in: &cancellables)
    }
    
    private func bindRecord() {
        dailyRecordViewModel?.$weekDates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dates in
                self?.performWeekdayCollectionViewCell(weekDates: dates)
            }.store(in: &cancellables)
        
        dailyRecordViewModel?.$currentPhraseFromYesterday
            .receive(on: DispatchQueue.main)
            .sink { [weak self] phrase in
                self?.fromYesterdayView.setUpComponent(text: phrase)
            }.store(in: &cancellables)
        
        dailyRecordViewModel?.$dailyRecordList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dailyRecordList in
                self?.performCardCollectionViewCell(dailyRecords: dailyRecordList)
            }.store(in: &cancellables)
    }
}

// MARK: CollectionView Data Setting 관련 코드부
extension RecordViewController {
    private func setUpCardCollectionViewDataSource() {
        cardCollectionView.register(RecordCardCollectionViewCell.self, forCellWithReuseIdentifier: RecordCardCollectionViewCell.identifier)
        cardCollectionDiffableDataSource = RecordCardCollectionViewDiffableDataSource(collectionView: cardCollectionView) { (collectionView, indexPath, dailyRecord) ->
            RecordCardCollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordCardCollectionViewCell.identifier, for: indexPath) as? RecordCardCollectionViewCell else {
                return RecordCardCollectionViewCell()
            }
            
            cell.setUpComponent(record: dailyRecord)
            
            return cell
        }
    }
    
    private func setUpWeekdayCollectionViewDataSource() {
        weekdayCollectionView.register(ATTWeekdayCollectionViewCell.self, forCellWithReuseIdentifier: ATTWeekdayCollectionViewCell.identifier)
        weekdayCollectionDiffableDataSource = WeekdayCollectionViewDiffableDataSource(collectionView: weekdayCollectionView) { (collectionView, indexPath, date) ->
            ATTWeekdayCollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ATTWeekdayCollectionViewCell.identifier, for: indexPath) as? ATTWeekdayCollectionViewCell else {
                return ATTWeekdayCollectionViewCell()
            }
            
            cell.setUpComponent(date: date)
            return cell
        }
    }
    
    private func performCardCollectionViewCell(dailyRecords: [AttDailyRecord?]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AttDailyRecord?>()
        snapshot.appendSections([0])
        snapshot.appendItems(dailyRecords)
        cardCollectionDiffableDataSource.apply(snapshot)
        view.layoutIfNeeded()
    }
    
    private func performWeekdayCollectionViewCell(weekDates: [Date]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Date>()
        snapshot.appendSections([0])
        snapshot.appendItems(weekDates)
        weekdayCollectionDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: CollectionView Delegate
extension RecordViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrolling {
            updateCenterSelectedCardIndexPath()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == weekdayCollectionView {
            updateSelectedCardIndexPathWithWeekdayCollectionView()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrolling = true
        updateCenterSelectedCardIndexPath()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case cardCollectionView:
            guard let cardCollectionViewCell = cardCollectionView.cellForItem(at: indexPath) as? RecordCardCollectionViewCell else { return }
            
            if cardCollectionViewCell.getRecordStatus() == .exist {
                presentRecordBrowseViewController()
            } else {
                presentAddRecordViewController()
            }
        case weekdayCollectionView:
            isScrolling = false
            
            guard let dateViewModel = dailyRecordViewModel else { return }
            let cardIndexPath = IndexPath(row: indexPath.row % dateViewModel.weekday, section: 0)
            
            for itemIndexPath in weekdayCollectionView.indexPathsForVisibleItems where itemIndexPath != indexPath {
                collectionView.deselectItem(at: itemIndexPath, animated: false)
            }
            
            dateViewModel.updateSelectedCardIndexPath(as: cardIndexPath)
            dateViewModel.updateCurrentSelectedDateIndexPath(as: indexPath)
            
            cardCollectionView.scrollToItem(at: cardIndexPath, at: .centeredHorizontally, animated: true)
        default:
            return
        }
    }
}

// MARK: CollectionView Centered Item Index 갱신 관련 코드부
extension RecordViewController {
    func centerCellIndexPath(in collectionView: UICollectionView) -> IndexPath? {
        
        let centerX = collectionView.contentOffset.x + collectionView.frame.width / 2
        let centerY = collectionView.contentOffset.y + collectionView.frame.height / 2
        let centerPoint = CGPoint(x: centerX, y: centerY)
        
        if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            return centerIndexPath
        }
        
        return nil
    }
    
    func updateCenterSelectedCardIndexPath() {
        guard let centerSelectedCardIndexPath = centerCellIndexPath(in: cardCollectionView) else { return }
        
        dailyRecordViewModel?.updateSelectedCardIndexPath(as: centerSelectedCardIndexPath)
        dailyRecordViewModel?.updateCurrentSelectedDateIndexPath(cardCollectionViewIndexPath: centerSelectedCardIndexPath)
    }
    
    func updateSelectedCardIndexPathWithWeekdayCollectionView() {
        guard let centerIndexPath = centerCellIndexPath(in: weekdayCollectionView) else { return }
        dailyRecordViewModel?.updateCenteredDateWithIndexPath(as: centerIndexPath)
    }
}

// MARK: Animation 코드부
extension RecordViewController {
    private func scrollToInitialPosition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let dateViewModel = self?.dailyRecordViewModel else { return }
            let dateSelectedIndex = dateViewModel.selectedDateIndexPath
            let cardCollectionViewIndex = dateSelectedIndex.row % dateViewModel.weekday
            
            self?.cardCollectionView.scrollToItem(at: IndexPath(row: cardCollectionViewIndex, section: 0), at: .centeredHorizontally, animated: true)
            self?.weekdayCollectionView.scrollToItem(at: dateSelectedIndex, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func weekdayCollectionViewVisible(as status: Bool) {
        let targetAlphaValue: CGFloat = status == true ? 1 : 0
        UIView.transition(with: weekdayCollectionView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.weekdayCollectionView.alpha = targetAlphaValue
        })
    }
    
    private func fromYesterdayViewVisible(as status: Bool) {
        let value: CGFloat = status == true ? 0 : 61
        UIView.transition(with: fromYesterdayView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self = self else { return }
            self.fromYesterdayView.snp.updateConstraints { make in
                make.height.equalTo(value)
            }
            
            self.fromYesterdayView.superview?.layoutIfNeeded()
            self.fromYesterdayView.isHidden = status
        })
    }
    
    private func presentRecordBrowseViewController() {
        let recordBrowseViewController = RecordBrowseViewController(dailyRecordViewModel: dailyRecordViewModel)
        recordBrowseViewController.modalPresentationStyle = .automatic
        self.navigationController?.present(recordBrowseViewController, animated: true)
    }
    
    private func presentAddRecordViewController() {
        let addRecordViewController = UINavigationController(rootViewController: AddColorViewController(recordCreationViewModel: RecordCreationViewModel(phraseFromYesterday: dailyRecordViewModel?.currentPhraseFromYesterday)))
        addRecordViewController.navigationBar.tintColor = .green
        addRecordViewController.modalPresentationStyle = .fullScreen
        present(addRecordViewController, animated: true)
    }
}
