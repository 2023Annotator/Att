//
//  MainViewModel.swift
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

final class MainViewModel: ViewModelType {
    @Published var centeredIdx: IndexPath = IndexPath(row: 0, section: 0)
    @Published var weekdayVisibleStatus: Bool = false
    
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
    
    func changeCenteredItemIdx(as idx: IndexPath) {
        centeredIdx = idx
    }
}
