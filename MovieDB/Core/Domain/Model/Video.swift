//
//  Video.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation

protocol Video {
  var identifier: Int { get }
  var key: String { get }
  var site: String { get }
  var type: String { get }
}
