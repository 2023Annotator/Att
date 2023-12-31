//
//  MainPageViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

final class MainPageViewController: UIViewController {
    
    private let calendarButton: UIBarButtonItem = {
        let image = UIImage(named: "calendar")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        let button = UIBarButtonItem(image: image)
        return button
    }()
    
    private lazy var segmentedControl: ATTSegmentedControl = {
        let control = ATTSegmentedControl(items: ["Rec.", "Analysis"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return viewController
    }()
    
    private lazy var recordViewController: RecordViewController = {
        guard let recordViewModel = self.weekdayVisibilityViewModel,
              let dailyRecordViewModel = self.dailyRecordViewModel else { return RecordViewController(weekdayVisibilityViewModel: WeekdayVisiblityViewModel(), dailyRecordViewModel: DailyRecordViewModel()) }
        
        let viewController = RecordViewController(weekdayVisibilityViewModel: recordViewModel, dailyRecordViewModel: dailyRecordViewModel)
        return viewController
    }()
    
    private lazy var analysisViewController: AnalysisListViewController = {
        let viewController = AnalysisListViewController(analysisViewModel: AnalysisViewModel(manager: recordAnalysisManager))
        return viewController
    }()
    
    private lazy var recordAnalysisManager: RecordAnalysisManager = {
        let manager = RecordAnalysisManager(wordAnalysisManager: WordAnalysisManager())
        return manager
    }()
    
    private var weekdayVisibilityViewModel: WeekdayVisiblityViewModel?
    private var dailyRecordViewModel: DailyRecordViewModel?
    private var cancellables = Set<AnyCancellable>()
    
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = CGRect(x: 0, y: segmentedControl.frame.height, width: view.frame.width, height: view.frame.height - segmentedControl.frame.height)
    }
    
    private func configure() {
        setUpPageViewController()
        setUpConstriants()
        setUpStyle()
        setUpNavigationBar()
        setUpAction()
        bind()
    }
    
    private func setUpPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(constraints.space8)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
    }
    
    private func setUpStyle() { }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Annotation"
        navigationItem.rightBarButtonItem = calendarButton
    }
    
    private func setUpAction() {
        segmentedControl.selectedSegmentIndexPublisher
            .sink { [weak self] selectedIndex in
                guard let self = self else { return }
                switch selectedIndex {
                case 0:
                    self.pageViewController.setViewControllers([self.recordViewController], direction: .reverse, animated: true, completion: nil)
                    self.disappearCalendarButton(as: false)
                case 1:
                    self.pageViewController.setViewControllers([self.analysisViewController], direction: .forward, animated: true, completion: nil)
                    self.disappearCalendarButton(as: true)
                default:
                    break
                }
            }.store(in: &cancellables)
        
        calendarButton.tapPublisher
            .sink { [weak self] _ in
                self?.showCalendar()
            }.store(in: &cancellables)
    }
    
    private func bind() { }
}

extension MainPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = pageViewController.viewControllers else { return nil }
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = currentIndex - 1
        if previousIndex >= 0 {
            return viewControllers[previousIndex]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = pageViewController.viewControllers else { return nil }
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = currentIndex + 1
        if nextIndex < viewControllers.count {
            return viewControllers[nextIndex]
        } else {
            return nil
        }
    }
}

extension MainPageViewController {
    private func disappearCalendarButton(as status: Bool) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.calendarButton.isHidden = status
        })
    }
    
    private func showCalendar() {
        guard let dailyRecordViewModel = dailyRecordViewModel else { return }
        let calendarViewController = CalendarViewController(dailyRecordViewModel: dailyRecordViewModel)
        if let sheetPresentationController = calendarViewController.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
        self.present(calendarViewController, animated: true, completion: nil)
    }
}
