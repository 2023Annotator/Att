//
//  UIViewController+.swift
//  Att
//
//  Created by 황정현 on 2023/09/20.
//

import UIKit.UIViewController

extension UIViewController {
    // https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
