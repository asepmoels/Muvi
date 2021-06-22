//
//  VideoEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import ObjectMapper

public struct VideoEntity: Video, Mappable {
  public var identifier: Int = 0
  public var key: String = ""
  public var site: String = ""
  public var type: String = ""

  public init?(map: Map) {
    mapping(map: map)
  }

  public mutating func mapping(map: Map) {
    type <- map["type"]
    identifier <- map["id"]
    key <- map["key"]
    site <- map["site"]
  }
}
