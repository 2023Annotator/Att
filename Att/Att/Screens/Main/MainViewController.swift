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

final class RecordCardCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<String?, Int> { }
final class WeekdayCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<String?, Int> { }

final class MainViewController: UIViewController {

    private let mypageButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "person")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()
    
    private let calendarButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(named: "calendar")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()
    
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
        return view
    }()
    
    private var cardCollectionDiffableDataSource: RecordCardCollectionViewDiffableDataSource!
    private var cardCollectionViewSnapshot = NSDiffableDataSourceSnapshot<String?, Int>()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 7 // TEST
        pageControl.pageIndicatorTintColor = .gray100
        pageControl.currentPageIndicatorTintColor = .green
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private lazy var weekdayCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 44, height: 56)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Constraints.shared.space12
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.isScrollEnabled = true
        view.isPagingEnabled = true
        view.contentInsetAdjustmentBehavior = .always
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        return view
    }()
    
    private var weekdayCollectionDiffableDataSource: WeekdayCollectionViewDiffableDataSource!
    private var weekdayCollectionViewSnapshot = NSDiffableDataSourceSnapshot<String?, Int>()
    
    private var viewModel: MainViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // TODO: ViewModel 편입 여부 고려
    var isScrolling = true
    
    init(viewModel: MainViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
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
        setUpDelegate()
        setUpNavigationBar()
        setUpCollectionView()
        setUpAction()
        bind()
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(fromYesterdayView)
        fromYesterdayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(constraints.space16)// TEMP
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
            make.top.equalTo(cardCollectionView.snp.bottom).offset(constraints.space8)
            make.centerX.equalToSuperview()
            make.height.equalTo(12)
        }
        
        view.addSubview(weekdayCollectionView)
        weekdayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(constraints.space24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
    }

    private func setUpDelegate() {
        cardCollectionView.delegate = self
        weekdayCollectionView.delegate = self
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Annotation"
        navigationItem.leftBarButtonItem = mypageButton
        navigationItem.rightBarButtonItem = calendarButton
    }
    
    private func setUpCollectionView() {
        setUpCardCollectionViewDataSource()
        performCardCollectionViewCell()
        setUpWeekdayCollectionViewDataSource()
        performWeekdayCollectionViewCell()
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
        
        let input = MainViewModel.Input(
            upSwipePublisher: upSwipeGesture.swipePublisher,
            downSwipePublisher: downSwipeGesture.swipePublisher
        )
        
        _ = viewModel?.transform(input: input)
        viewModel?.$weekdayVisibleStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.weekdayCollectionViewVisible(as: status)
                self?.fromYesterdayViewVisible(as: status)
            }.store(in: &cancellables)
    }
    
    private func bind() {
        viewModel?.$centeredIdx
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
                
                cardCollectionView.superview?.layoutIfNeeded()
                
                self?.pageControl.currentPage = indexPath.row
                
                guard let weekdayCollectionView = self?.weekdayCollectionView else { return }
                for cell in weekdayCollectionView.visibleCells {
                    guard let cell = cell as? ATTWeekdayCollectionViewCell else { return }
                    if weekdayCollectionView.cellForItem(at: indexPath) == cell {
                        cell.updateSelectedCellDesign(status: .selected)
                    } else {
                        cell.updateSelectedCellDesign(status: .deselected)
                    }
                }
            }.store(in: &cancellables)
    }
}

// MARK: CollectionView Data Setting 관련 코드부
extension MainViewController {
    private func setUpCardCollectionViewDataSource() {
        cardCollectionView.register(RecordCardCollectionViewCell.self, forCellWithReuseIdentifier: RecordCardCollectionViewCell.identifier)
        cardCollectionDiffableDataSource = RecordCardCollectionViewDiffableDataSource(collectionView: cardCollectionView) { (collectionView, indexPath, cellNumber) ->
            RecordCardCollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordCardCollectionViewCell.identifier, for: indexPath) as? RecordCardCollectionViewCell else {
                return RecordCardCollectionViewCell()
            }
            
            // TEST
            cell.setUpComponent(data: cellNumber)
            return cell
        }
    }
    
    private func performCardCollectionViewCell() {
        // TEMP & TEST
        let cellNum: [Int] = (0..<7).map { Int($0) }
        
        cardCollectionViewSnapshot.appendSections(["TEMP"])
        cardCollectionViewSnapshot.appendItems(cellNum)
        cardCollectionDiffableDataSource.apply(cardCollectionViewSnapshot)
    }
    
    private func setUpWeekdayCollectionViewDataSource() {
        weekdayCollectionView.register(ATTWeekdayCollectionViewCell.self, forCellWithReuseIdentifier: ATTWeekdayCollectionViewCell.identifier)
        weekdayCollectionDiffableDataSource = WeekdayCollectionViewDiffableDataSource(collectionView: weekdayCollectionView) { (collectionView, indexPath, cellNumber) ->
            ATTWeekdayCollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ATTWeekdayCollectionViewCell.identifier, for: indexPath) as? ATTWeekdayCollectionViewCell else {
                return ATTWeekdayCollectionViewCell()
            }
            
            // TEST
            cell.setUpComponent(data: cellNumber)
            return cell
        }
    }
    
    private func performWeekdayCollectionViewCell() {
        // TEMP & TEST
        let cellNum: [Int] = (1...21).map { Int($0) }
        
        weekdayCollectionViewSnapshot.appendSections(["EE"])
        weekdayCollectionViewSnapshot.appendItems(cellNum)
        weekdayCollectionDiffableDataSource.apply(weekdayCollectionViewSnapshot)
    }
}

// MARK: CollectionView Delegate
extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrolling {
            detectCenteredCard()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrolling = true
        detectCenteredCard()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case cardCollectionView:
            // TODO: Record Page 연결
            print("SHOW RECORD PAGE")
        case weekdayCollectionView:
            isScrolling = false
            guard let viewModel = viewModel else { return }
            viewModel.changeCenteredItemIdx(as: indexPath)
            cardCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        default:
            return
        }
    }
}

// MARK: CollectionView Centered Item Index 갱신 관련 코드부
extension MainViewController {
    func detectCenteredCard() {
        let centerPoint = view.convert(view.center, to: cardCollectionView)
        if let centerIndexPath = cardCollectionView.indexPathForItem(at: centerPoint) {
            viewModel?.changeCenteredItemIdx(as: centerIndexPath)
        }
    }
}

// MARK: ViewModel Status에 따른 View Constraints 및 Hidden 상태 관련 코드부
extension MainViewController {
    func weekdayCollectionViewVisible(as status: Bool) {
        UIView.transition(with: weekdayCollectionView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.weekdayCollectionView.isHidden = !status
        })
    }
    
    func fromYesterdayViewVisible(as status: Bool) {
        let value: CGFloat = status == true ? Constraints.shared.space16 - 61 : Constraints.shared.space16
        UIView.transition(with: fromYesterdayView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self = self else { return }
            self.fromYesterdayView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(value)
            }
            self.fromYesterdayView.superview?.layoutIfNeeded()
            
            self.fromYesterdayView.isHidden = status
        })
    }
}
