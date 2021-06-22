//
//  UIImage.swift
//  Common
//
//  Created by Asep Mulyana on 21/06/21.
//

import UIKit

public extension UIImage {
  static let tabHome = image(named: "tab_home")!
  static let tabAbout = image(named: "tab_about")!
  static let tabSearch = image(named: "tab_search")!
  static let tabFavorite = image(named: "tab_fav")!
  static let navbarLogo = image(named: "logo_navbar")!.withRenderingMode(.alwaysOriginal)
  static let searchIcon = image(named: "icon_search")!
  static let backButton = image(named: "btn_back")!
  static let movieIcon = image(named: "icon_movie")!
  static let unknownIcon = image(named: "icon_unknown")!
  static let favoriteButton = image(named: "btn_fav")!
  static let playButton = image(named: "btn_play")!
  static let plusButton = image(named: "btn_plus")!
  static let gradientImage = image(named: "img_gradient")!
  static let aboutFoto = image(named: "foto")!

  static func image(named: String) -> UIImage? {
    UIImage(named: named, in: Bundle(identifier: "com.asepmoels.Common"), compatibleWith: nil)
  }
}
