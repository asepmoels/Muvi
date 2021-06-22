//
//  String+Localized.swift
//  Common
//
//  Created by Asep Mulyana on 22/06/21.
//

import Foundation

extension String {
  public func localized() -> String {
    let bundle = Bundle(identifier: "com.asepmoels.Common") ?? .main
    let result = bundle.localizedString(forKey: self, value: nil, table: nil)
    return result
  }
}
