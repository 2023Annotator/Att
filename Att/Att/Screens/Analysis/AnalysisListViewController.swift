//
//  AnalysisListViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import UIKit

class AnalysisListViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: property 선언부
    private lazy var annualView: AnnualAnalysisView = {
        let view = AnnualAnalysisView()
        return view
    }()
    
    private lazy var monthListView: MonthListView = {
        let view = MonthListView()
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
        setUpStyle()
        setUpMonthCollectionView()
        setUpAction()
        bind()
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
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
            make.top.equalTo(annualView.snp.bottom).offset(constraints.space40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(itemHeight * 12 + 50) // TODO: item 갯수 받아와서 높이 작성
            make.bottom.equalToSuperview()
        }
    }
    // MARK: 최상위 뷰의 Style 지정 (layer.cornerRadius etc) - Optional
    // 최상위 뷰를 제외한 나머지 UI Components는 각 Components 클로저 내부에서 Style 설정을 완료할 수 있게 만들기
    private func setUpStyle() { }
    
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
}
