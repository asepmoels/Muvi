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
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
  }
}
