//
//  SearchTextField.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Common

class SearchTextField: UITextField {
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 36))
    configureViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureViews()
  }

  private func configureViews() {
    rightViewMode = .always
    let imageView = UIImageView(image: UIImage.searchIcon)
    imageView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
    rightView = imageView
    tintColor = .white
    textColor = UIColor.white.withAlphaComponent(0.85)
    returnKeyType = .done
    attributedPlaceholder = NSAttributedString(string: "Search",
                                               attributes: [
                                                NSAttributedString.Key.foregroundColor: UIColor.gray
                                               ])
  }
}
