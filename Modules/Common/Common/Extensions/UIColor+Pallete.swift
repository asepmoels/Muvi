//
//  UIColor+Pallete.swift
//  Common
//
//  Created by Asep Mulyana on 21/06/21.
//

import UIKit

public extension UIColor {
  static let mainColor = UIColor(hexCode: 0x25272A)
  static let mainBarColor = UIColor(hexCode: 0x202123)
  static let primaryYellow = UIColor(hexCode: 0xFFD130)

  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    self.init(red: CGFloat(red) / 255.0,
              green: CGFloat(green) / 255.0,
              blue: CGFloat(blue) / 255.0,
              alpha: 1.0)
  }

  convenience init(hexCode: Int) {
    self.init(red: (hexCode >> 16) & 0xff,
              green: (hexCode >> 8) & 0xff,
              blue: hexCode & 0xff)
  }
}
