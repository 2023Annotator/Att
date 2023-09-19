//
//  RecordViewModel.swift
//  Att
//
//  Created by 황정현 on 2023/08/10.
//

import Combine
import CombineCocoa
import UIKit

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
}

final class WeekdayVisiblityViewModel: ViewModelType {
    @Published var weekdayVisibleStatus: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let upSwipePublisher: AnyPublisher<UISwipeGestureRecognizer, Never>
        let downSwipePublisher: AnyPublisher<UISwipeGestureRecognizer, Never>
    }

    struct Output {
        let isWeekdayVisible: AnyPublisher<Bool, Never>
    }
    
    func transform(input: Input) {
        input.downSwipePublisher.sink { [weak self] _ in
            if self?.weekdayVisibleStatus == true {
                self?.weekdayVisibleStatus = false
            }
        }.store(in: &cancellables)
        
        input.upSwipePublisher.sink { [weak self] _ in
            if self?.weekdayVisibleStatus == false {
                self?.weekdayVisibleStatus = true
            }
        }.store(in: &cancellables)
    }
}
