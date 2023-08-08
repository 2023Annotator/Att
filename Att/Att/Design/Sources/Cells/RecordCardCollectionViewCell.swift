//
//  RecordCardCollectionViewCell.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import UIKit
import SnapKit

final class RecordCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: property 선언부
    static let identifier = "RecordCardCollectionViewCell"
    
    private var blurEffectView: UIVisualEffectView = {
        
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.alpha = 0.8
        return view
    }()
    
    private var cardView: ATTCardView?
    
    // MARK: Init 선언부
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(recordStatus: .exist)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure(recordStatus: RecordStatus) {
        setUpConstriants(recordStatus: recordStatus)
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
    private func setUpConstriants(recordStatus: RecordStatus) {
        
        switch recordStatus {
        case .exist:
            cardView = RecordExistCardView()
        case .nonExist:
            cardView = RecordNonExistCardView()
        }
        
        guard let cardView = cardView else { return }
        addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        cardView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // TEMPORARY parameter is Int -> Model
    func setUpComponent(data: Int) {
//        print("GOOD")
    }
    
    func blurEffect(isHidden: Bool) {
        blurEffectView.isHidden = isHidden
    }
}
