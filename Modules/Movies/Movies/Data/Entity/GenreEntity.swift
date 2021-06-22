//
//  GenreEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

public class GenreEntity: Object, Genre, Mappable {
  @objc dynamic public var identifier: Int = 0
  @objc dynamic public var name: String = ""

  public override init() {
    super.init()
  }

  public required init?(map: Map) {
    super.init()
    mapping(map: map)
  }

  public func mapping(map: Map) {
    identifier <- map["id"]
    name <- map["name"]
  }

  override class public func primaryKey() -> String? {
    "identifier"
  }
}
