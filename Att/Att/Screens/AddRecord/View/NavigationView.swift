//
//  NavigationView.swift
//  Att
//
//  Created by 정제인 on 2023/09/10.
//

import UIKit

class NavigationView: UIView {

    
    private let chevronButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()
    
    // 우측 close 버튼
    private let xmarkButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return button
    }()
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = chevronButton
        navigationItem.rightBarButtonItem = xmarkButton
    }

    
    // MARK: Init 선언부
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
