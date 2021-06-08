//
//  CastEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import ObjectMapper

struct CastEntity: Cast, Mappable {
  var identifier: Int = 0
  var name: String = ""
  var fotoURL: URL?

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    identifier <- map["id"]
    name <- map["name"]
    fotoURL <- (map["profile_path"], ImageURLTransform())
  }
}
