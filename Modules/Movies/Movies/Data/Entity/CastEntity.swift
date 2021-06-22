//
//  CastEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import ObjectMapper

public struct CastEntity: Cast, Mappable {
  public var identifier: Int = 0
  public var name: String = ""
  public var fotoURL: URL?

  public init?(map: Map) {
    mapping(map: map)
  }

  mutating public func mapping(map: Map) {
    identifier <- map["id"]
    name <- map["name"]
    fotoURL <- (map["profile_path"], ImageURLTransform())
  }
}
