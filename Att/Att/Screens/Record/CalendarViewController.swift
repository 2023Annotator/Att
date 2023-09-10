//
//  CalendarViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/07.
//

import Combine
import SnapKit
import UIKit

final class CalendarViewController: UIViewController {
    
    private lazy var calendarView: UICalendarView = {
        let view = UICalendarView()
        view.selectionBehavior = dateSelection
        
        var gregorianCalendar = Calendar(identifier: .gregorian)
        gregorianCalendar.firstWeekday = 2
        view.calendar = gregorianCalendar
        view.locale = Locale(identifier: "ko_KR")
        view.fontDesign = .rounded
        view.tintColor = .green
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var dateSelection: UICalendarSelectionSingleDate = {
        let selection = UICalendarSelectionSingleDate(delegate: self)
        return selection
    }()
    
    private var dateViewModel: DateViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(dateViewModel: DateViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.dateViewModel = dateViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setUpDelegate()
        bind()
    }
    
    private func setUpConstraints() {
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpDelegate() {
        calendarView.delegate = self
    }
    
    private func bind() {
        dateViewModel?.$selectedDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dateComponent in
                self?.updateSelectedDate(as: dateComponent)
                self?.reloadDateView(date: dateComponent?.date)
            }.store(in: &cancellables)
    }
}

extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        guard let dateComponents = dateComponents else { return }
        dateViewModel?.changeSelectedDate(as: dateComponents)
        reloadDateView(date: Calendar.current.date(from: dateComponents))
        dismissCalendarView()
    }
}

extension CalendarViewController {
    func reloadDateView(date: Date?) {
        guard let date = date else { return }
        let calendar = Calendar.current
        calendarView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date)], animated: true)
    }
    
    private func dismissCalendarView() {
        dateViewModel?.dismissCalendarView()
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSelectedDate(as date: DateComponents?) {
        guard let date = date else { return }
        dateSelection.setSelected(date, animated: true)
        calendarView.selectionBehavior = dateSelection
    }
}
