//
//  VideoEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import ObjectMapper

struct VideoEntity: Video, Mappable {
  var identifier: Int = 0
  var key: String = ""
  var site: String = ""
  var type: String = ""

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    type <- map["type"]
    identifier <- map["id"]
    key <- map["key"]
    site <- map["site"]
  }
}
