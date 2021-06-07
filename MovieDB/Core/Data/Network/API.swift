//
//  API.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import Moya
import Alamofire

enum API {
  case nowPlaying
}

extension API: TargetType {
  var baseURL: URL {
    URL(string: "https://api.themoviedb.org/3/")!
  }

  var path: String {
    switch self {
    case .nowPlaying:
      return "movie/now_playing"
    }
  }

  var task: Task {
    let defaultParams = ["api_key": Config.movieDBApiKey]
    switch self {
    default:
      break
    }
    return .requestParameters(parameters: defaultParams, encoding: URLEncoding.queryString)
  }

  var method: Alamofire.HTTPMethod {
    .get
  }

  var sampleData: Data {
    Data()
  }

  var headers: [String: String]? {
    nil
  }
}
