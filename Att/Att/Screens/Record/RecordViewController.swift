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

final class RecordCardCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Int, Date> { }
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
        pageControl.numberOfPages = 7 // TEST
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
    
    private var recordViewModel: RecordViewModel?
    private var dateViewModel: DateViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // TODO: ViewModel 편입 여부 고려
    var isScrolling = true
    var isAppear = false
    
    init(recordViewModel: RecordViewModel, dateViewModel: DateViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.recordViewModel = recordViewModel
        self.dateViewModel = dateViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isAppear {
            scrollToInitialPosition()
            isAppear.toggle()
        }
    }

    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
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
        
        let input = RecordViewModel.Input(
            upSwipePublisher: upSwipeGesture.swipePublisher,
            downSwipePublisher: downSwipeGesture.swipePublisher
        )
        
        _ = recordViewModel?.transform(input: input)
        
        recordViewModel?.$weekdayVisibleStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.weekdayCollectionViewVisible(as: status)
                self?.fromYesterdayViewVisible(as: status)
            }.store(in: &cancellables)
    }
    
    private func bind() {
        
        dateViewModel?.$isCalendarViewDismissed
            .sink { [weak self] isDismissed in
                if isDismissed {
                    self?.isScrolling = false
                    self?.scrollToInitialPosition()
                }
            }.store(in: &cancellables)
        
        dateViewModel?.$dateSelectedIdx
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
                guard let recordViewModel = self?.recordViewModel else { return }
                recordViewModel.changeSelectedItemIdx(as: currentIndexPath)
                
                self?.dateViewModel?.printAllComponent()
            }.store(in: &cancellables)
        
        dateViewModel?.$currentVisibleDates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dates in
                self?.performCardCollectionViewCell(weekDates: dates)
            }.store(in: &cancellables)

        dateViewModel?.$weekDates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dates in
                self?.performWeekdayCollectionViewCell(weekDates: dates)
            }.store(in: &cancellables)
        
        recordViewModel?.$selectedIdx
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
    
    private func scrollToInitialPosition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let dateSelectedIndex = self?.dateViewModel?.dateSelectedIdx else { return }
            let cardCollectionViewIndex = dateSelectedIndex.row % 7
            self?.cardCollectionView.scrollToItem(at: IndexPath(row: cardCollectionViewIndex, section: 0), at: .centeredHorizontally, animated: true)
            self?.weekdayCollectionView.scrollToItem(at: dateSelectedIndex, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: CollectionView Data Setting 관련 코드부
extension RecordViewController {
    private func setUpCardCollectionViewDataSource() {
        cardCollectionView.register(RecordCardCollectionViewCell.self, forCellWithReuseIdentifier: RecordCardCollectionViewCell.identifier)
        cardCollectionDiffableDataSource = RecordCardCollectionViewDiffableDataSource(collectionView: cardCollectionView) { (collectionView, indexPath, weekDates) ->
            RecordCardCollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordCardCollectionViewCell.identifier, for: indexPath) as? RecordCardCollectionViewCell else {
                return RecordCardCollectionViewCell()
            }
            
            // TODO: Date 대신 Model로 치환
            cell.setUpComponent(data: weekDates)
            return cell
        }
    }
    
    private func performCardCollectionViewCell(weekDates: [Date]) {
        // TODO: Date 대신 Model로 치환
        var snapshot = NSDiffableDataSourceSnapshot<Int, Date>()
        snapshot.appendSections([0])
        snapshot.appendItems(weekDates)
        cardCollectionDiffableDataSource.apply(snapshot)
    }
    
    private func setUpWeekdayCollectionViewDataSource() {
        weekdayCollectionView.register(ATTWeekdayCollectionViewCell.self, forCellWithReuseIdentifier: ATTWeekdayCollectionViewCell.identifier)
        weekdayCollectionDiffableDataSource = WeekdayCollectionViewDiffableDataSource(collectionView: weekdayCollectionView) { (collectionView, indexPath, date) ->
            ATTWeekdayCollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ATTWeekdayCollectionViewCell.identifier, for: indexPath) as? ATTWeekdayCollectionViewCell else {
                return ATTWeekdayCollectionViewCell()
            }
            
            // TODO: Date 대신 Model로 치환
            cell.setUpDate(date: date)
            return cell
        }
    }
    
    private func performWeekdayCollectionViewCell(weekDates: [Date]) {
        // TODO: Date 대신 Model로 치환
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
            detectSelectedCard()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case cardCollectionView:
            break
        case weekdayCollectionView:
            if let centerIndexPath = indexPathForCenterCell(in: weekdayCollectionView) {
                recordViewModel?.updateSelectedItemIdx()
                dateViewModel?.updateCenteredDate(as: centerIndexPath)
                view.layoutIfNeeded()
            }
        default:
            break
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrolling = true
        detectSelectedCard()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case cardCollectionView:
            // TODO: Record Page 연결
            print("SHOW RECORD PAGE")
        case weekdayCollectionView:
            isScrolling = false
            let currentIndexPath = IndexPath(row: indexPath.row % 7, section: 0)
            
            for itemIndexPath in weekdayCollectionView.indexPathsForVisibleItems where itemIndexPath != indexPath {
                collectionView.deselectItem(at: itemIndexPath, animated: false)
            }
            
            guard let recordViewModel = recordViewModel else { return }
            recordViewModel.changeSelectedItemIdx(as: currentIndexPath)
            guard let dateViewModel = dateViewModel else { return }
            dateViewModel.changeCurrentSelectedDateIdx(as: indexPath)
            cardCollectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
            
        default:
            return
        }
    }
}

// MARK: CollectionView Centered Item Index 갱신 관련 코드부
extension RecordViewController {
    func detectSelectedCard() {
        let centerPoint = view.convert(view.center, to: cardCollectionView)
        if let selectedIndexPath = cardCollectionView.indexPathForItem(at: centerPoint) {
            recordViewModel?.changeSelectedItemIdx(as: selectedIndexPath)
            dateViewModel?.changeCurrentSelectedDateIdx(cardCollectionViewIndexPath: selectedIndexPath)
        }
    }
    
    func indexPathForCenterCell(in collectionView: UICollectionView) -> IndexPath? {

        let centerX = collectionView.contentOffset.x + collectionView.frame.width / 2
        let centerY = collectionView.contentOffset.y + collectionView.frame.height / 2
        let centerPoint = CGPoint(x: centerX, y: centerY)

        if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            return centerIndexPath
        }

        return nil
    }

}

// MARK: ViewModel Status에 따른 View Constraints 및 Hidden 상태 관련 코드부
extension RecordViewController {
    func weekdayCollectionViewVisible(as status: Bool) {
        UIView.transition(with: weekdayCollectionView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.weekdayCollectionView.isHidden = !status
            self?.weekdayCollectionView.superview?.layoutIfNeeded()
        })
    }
    
    func fromYesterdayViewVisible(as status: Bool) {
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
}
