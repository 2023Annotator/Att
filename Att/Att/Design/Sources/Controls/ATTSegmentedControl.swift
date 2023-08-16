//
//  ATTSegmentedControl.swift
//  Att
//
//  Created by 황정현 on 2023/08/16.
//  https://medium.com/ios-app開發之世界這麼大/how-to-custom-uisegmentcontrol-71ac2bd69499

import UIKit

final class ATTSegmentedControl: UISegmentedControl {
    
    private(set) lazy var radius: CGFloat = bounds.height / 2
    
    private var segmentInset: CGFloat = 4.0 {
        didSet {
            if segmentInset == 0 {
                segmentInset = 4.0
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let normalTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        setTitleTextAttributes(normalTextAttributes, for: .normal)
        setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .gray50
        
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true
        
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
            selectedImageView.backgroundColor = .black
            selectedImageView.image = nil
            
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = self.radius
            selectedImageView.layer.borderWidth = 1
            selectedImageView.layer.borderColor = UIColor.gray50.cgColor
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")
        }
    }
}
