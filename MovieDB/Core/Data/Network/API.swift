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
  case popular
  case topRated
  case upcoming
  case trending
  case search(query: String)
  case detailMovie(movieId: String)
}

extension API: TargetType {
  var baseURL: URL {
    URL(string: "https://api.themoviedb.org/3/")!
  }

  var path: String {
    switch self {
    case .nowPlaying:
      return "movie/now_playing"
    case .popular:
      return "movie/popular"
    case .topRated:
      return "movie/top_rated"
    case .upcoming:
      return "movie/upcoming"
    case .trending:
      return "trending/movie/day"
    case .search:
      return "search/movie"
    case .detailMovie(let movieId):
      return "movie/\(movieId)"
    }
  }

  var task: Task {
    var defaultParams = ["api_key": Config.movieDBApiKey]
    switch self {
    case .search(let query) where query.count > 0:
      defaultParams["query"] = query
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
