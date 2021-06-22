//
//  UIViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Core
import SVProgressHUD

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

  func handleError(error: Error) {
    guard let message = (error as? ApiError)?.localizedDescription else { return }
    let alert = UIAlertController(title: "Error",
                                  message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }

  func handleDataState<T>(state: DataState<T>, onLoaded: (() -> Void)) {
    SVProgressHUD.dismiss()
    switch state {
    case .loading:
      SVProgressHUD.show()
    case .loaded,
         .empty:
      onLoaded()
    case .failed(let error):
      handleError(error: error)
    default:
      break
    }
  }
}
