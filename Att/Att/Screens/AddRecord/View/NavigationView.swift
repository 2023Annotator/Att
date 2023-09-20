//
//  NavigationView.swift
//  Att
//
//  Created by 정제인 on 2023/09/10.
//

import UIKit

final class NavigationView: UIView {
    private let chevronButton: UIBarButtonItem = {
        let testImage = UIImage()
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()
    
    private let xmarkButton: UIBarButtonItem = {
        let testImage = UIImage()
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = chevronButton
        navigationItem.rightBarButtonItem = xmarkButton
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setUpConstraints()
        setUpNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
    }
    
}
