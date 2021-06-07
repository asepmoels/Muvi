//
//  ImageURLTransform.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import ObjectMapper

struct ImageURLTransform: TransformType {
  typealias Object = URL
  typealias JSON = String

  func transformFromJSON(_ value: Any?) -> URL? {
    URL(string: Config.imageBaseURL + ((value as? String) ?? ""))
  }

  func transformToJSON(_ value: URL?) -> String? {
    "/" + (value?.lastPathComponent ?? "")
  }
}
