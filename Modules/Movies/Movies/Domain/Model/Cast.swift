//
//  Cast.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation

public protocol Cast {
  var identifier: Int { get }
  var name: String { get }
  var fotoURL: URL? { get }
}
