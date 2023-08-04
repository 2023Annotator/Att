//
//  MainViewController.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

class RecordCardCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<String?, Int> { }

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
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: setUpCollectionViewLayout())
        view.isScrollEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        view.decelerationRate = .fast
        return view
    }()
    
    private var cardCollectionDiffableDataSource: RecordCardCollectionViewDiffableDataSource!
    private var snapshot = NSDiffableDataSourceSnapshot<String?, Int>()
    
//    private lazy var cardView: ATTCardView = {
////        let view = RecordExistCardView()
//        let view = RecordNonExistCardView()
//        return view
//    }()
    
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
            make.height.equalTo(100)
        }
        
        view.addSubview(cardCollectionView)
        cardCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(540) // ORIGIN: 507.94
        }
    }
    
    // MARK: 최상위 뷰의 Style 지정 (layer.cornerRadius etc) - Optional
    // 최상위 뷰를 제외한 나머지 UI Components는 각 Components 클로저 내부에서 Style 설정을 완료할 수 있게 만들기
    private func setUpStyle() { }

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
    
    private func setUpCollectionViewLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewCompositionalLayout = {
            let itemSpacing: CGFloat = 7
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.scrollDirection = .horizontal
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemSpacing, bottom: 0, trailing: itemSpacing)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.88),
                heightDimension: .fractionalHeight(0.94)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return UICollectionViewCompositionalLayout(section: section, configuration: config)
        }()
        
        return layout
    }
}
