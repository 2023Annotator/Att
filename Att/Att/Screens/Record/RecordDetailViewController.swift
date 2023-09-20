//
//  RecordDetailViewController.swift
//  Att
//
//  Created by 정제인 on 2023/09/10.
//

import UIKit

class RecordDetailViewController: UIViewController {

    // 새롭게 생기는 ViewController
    
    
    private lazy var xmarkButton: UIBarButtonItem = {
        let testImage = UIImage() // TEST
        testImage.withTintColor(.yellow)
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        return button
    }()
    
    private lazy var modButton: UIButton = {
        let button = UIButton()
                
        button.setTitle("Back Button", for: .normal)
//        button.setTitleColor(.systemBlue, for: .normal)
//        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
                
        return button
    }()
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = xmarkButton
        navigationItem.rightBarButtonItem = xmarkButton
    }
    
    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpNavigationBar()
        setUpAction()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        
        if navigationController != nil {
            xmarkButton.isHidden = true
        }
    }
    
    private func setUpConstriants() {
        let constraints = Constraints.shared
        
        
    }
    
    private func setUpStyle() {
        view.backgroundColor = .white
    }
    
    // MARK: TabPulisher etc - Optional
    private func setUpAction() { }
    
    // MARK: ViewModel Stuff - Optional
    private func bind() { }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
