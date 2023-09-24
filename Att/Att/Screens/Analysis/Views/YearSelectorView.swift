//
//  YearSelectorView.swift
//  Att
//
//  Created by 황정현 on 2023/09/05.
//

import Combine
import UIKit

final class YearSelectorView: UIView {

    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = .title3
        label.textAlignment = .center
        label.textColor = .white
        label.text = "2023" // TEST
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.left")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var analysisViewModel: AnalysisViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(analysisViewModel: AnalysisViewModel?) {
        super.init(frame: CGRect.zero)
        self.analysisViewModel = analysisViewModel
        setUpConstraints()
        setUpStyle()
        setUpAction()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        [
            yearLabel,
            leftButton,
            rightButton
        ].forEach {
            addSubview($0)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    private func setUpStyle() {
        backgroundColor = .clear
    }
    
    private func setUpAction() {
        leftButton.tapPublisher
            .sink { [weak self] in
                self?.analysisViewModel?.decreaseYear()
            }.store(in: &cancellables)
        
        rightButton.tapPublisher
            .sink { [weak self] in
                self?.analysisViewModel?.increaseYear()
            }.store(in: &cancellables)
    }
    
    private func bind() {
        analysisViewModel?.$currentYear
            .sink { [weak self] year in
                self?.setUpYearLabel(year: year)
                self?.isRightButtonUserInteractionEnabled(with: year)
            }.store(in: &cancellables)
    }
    
    private func setUpYearLabel(year: Int) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.yearLabel.text = "\(year)"
        }
    }
    
    private func isRightButtonUserInteractionEnabled(with year: Int) {
        let isEnabled = !(String(year) == Date().year())
        rightButton.isUserInteractionEnabled = isEnabled
        changeRightButtonTintColor(isUserInteractionEnabled: isEnabled)
    }
    
    private func changeRightButtonTintColor(isUserInteractionEnabled: Bool) {
        var imageTintColor: UIColor = .white
        
        if !isUserInteractionEnabled {
            imageTintColor = .gray100
        }
        
        let image = UIImage(systemName: "chevron.right")?
            .withTintColor(imageTintColor, renderingMode: .alwaysOriginal)
        rightButton.setImage(image, for: .normal)
    }
}
