//
//  GenreEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import ObjectMapper
import RealmSwift

class GenreEntity: Object, Genre, Mappable {
  @objc dynamic var identifier: Int = 0
  @objc dynamic var name: String = ""

  override init() {
    super.init()
  }

  required init?(map: Map) {
    super.init()
    mapping(map: map)
  }

  func mapping(map: Map) {
    identifier <- map["id"]
    name <- map["name"]
  }

  override class func primaryKey() -> String? {
    "identifier"
  }
}
