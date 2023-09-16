//
//  RecordCardCollectionViewCell.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

final class RecordCardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecordCardCollectionViewCell"
    
    private var blurEffectView: UIVisualEffectView = {
        
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.alpha = 0.8
        return view
    }()
    
    private var recordExistView = RecordExistCardView()
    private var recordNonExistView = RecordNonExistCardView()
    
    private var cardView: ATTCardView = ATTCardView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        setUpConstriants()
    }
    
    private func setUpConstriants() {
        addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        cardView.addSubview(recordExistView)
        recordExistView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        cardView.addSubview(recordNonExistView)
        recordNonExistView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        cardView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setUpComponent(record: DailyRecordModel?) {
        
        var recordStatus: RecordStatus = .exist
        if record?.mood == nil {
            recordStatus = .nonExist
            guard let dateRelation = record?.date.relativeDate() else { return }
            recordNonExistView.setUpComponent(dateRelation: dateRelation)
        } else {
            guard let record = record else { return }
            recordExistView.setUpComponent(record: record)
        }
        
        switch recordStatus {
        case .exist:
            recordExistView.isHidden = false
            recordNonExistView.isHidden = true
        case .nonExist:
            recordExistView.isHidden = true
            recordNonExistView.isHidden = false
        }
    }
    
    func blurEffect(isHidden: Bool) {
        blurEffectView.isHidden = isHidden
    }
}
