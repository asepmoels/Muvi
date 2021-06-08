//
//  UIViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit

extension UIViewController {
  func setupTheme() {
    navigationController?.navigationBar.backgroundColor = .mainBarColor
    navigationController?.navigationBar.barTintColor = .mainBarColor
    navigationController?.navigationBar.tintColor = .primaryYellow
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
  }
}
