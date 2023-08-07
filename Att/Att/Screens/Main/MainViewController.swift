//
//  MainViewController.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

final class RecordCardCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<String?, Int> { }

final class MainViewController: UIViewController {

    // MARK: property 선언부
    private let mypageButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: testImage)
        return button
    }()
    
    private let calendarButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: testImage)
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
    
    // TODO: currentPageIndicatorTintColor 변경 관련 메소드 작성
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 7 // TEST
        pageControl.pageIndicatorTintColor = .systemGray // TEMP: Default로 특정 색상 지정 예정
        pageControl.currentPageIndicatorTintColor = .red // TEMP: VM로부터 데이터를 받아서 지정 예정
        return pageControl
    }()
    
    private var cardCollectionDiffableDataSource: RecordCardCollectionViewDiffableDataSource!
    private var snapshot = NSDiffableDataSourceSnapshot<String?, Int>()

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
    }

    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpDelegate()
        setUpNavigationBar()
        setUpCollectionViewDataSource()
        performCell()
        setUpAction()
        bind()
        
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(fromYesterdayView)
        fromYesterdayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(constraints.space16)// TEMP
            make.leading.equalToSuperview().offset(constraints.space16)
            make.trailing.equalToSuperview().offset(-constraints.space16)
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
//            make.height.equalTo(viewHeight) // ORIGIN: 507.94
            make.height.equalTo(viewHeight)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(cardCollectionView.snp.bottom).offset(constraints.space24) // ORIGIN: 23.06
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
        }
    }
    
    // MARK: 최상위 뷰의 Style 지정 (layer.cornerRadius etc) - Optional
    // 최상위 뷰를 제외한 나머지 UI Components는 각 Components 클로저 내부에서 Style 설정을 완료할 수 있게 만들기
    private func setUpStyle() { }

    private func setUpDelegate() { }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Annotation"
        navigationItem.leftBarButtonItem = mypageButton
        navigationItem.rightBarButtonItem = calendarButton
    }

    // MARK: TabPulisher etc - Optional
    private func setUpAction() { }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }
}

extension MainViewController {
    private func setUpCollectionViewDataSource() {
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
    
    private func performCell() {
        let cellNum: [Int] = (0..<10).map { Int($0) }
        
        var snapShot = NSDiffableDataSourceSnapshot<String?, Int>()
        snapShot.appendSections(["TEMP"])
        snapShot.appendItems(cellNum)
        cardCollectionDiffableDataSource.apply(snapShot)
    }
}
