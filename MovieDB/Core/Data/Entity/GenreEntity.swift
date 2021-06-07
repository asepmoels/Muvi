//
//  GenreEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import ObjectMapper

struct GenreEntity: Genre, Mappable {
  var identifier: Int = 0
  var name: String = ""

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    identifier <- map["id"]
    name <- map["name"]
  }
}
