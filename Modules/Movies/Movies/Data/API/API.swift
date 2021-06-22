//
//  API.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation

public enum API {
  case nowPlaying
  case popular
  case topRated
  case upcoming
  case trending
  case search(query: String)
  case detailMovie(movieId: String)
}

public extension API {
  var url: URL {
    let params = parameter.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    let urlString = baseURL.appending(path)
      .appending("?")
      .appending(params)
    return URL(string: urlString) ?? URL.init(fileURLWithPath: "")
  }

  private var baseURL: String {
    "https://api.themoviedb.org/3/"
  }

  private var path: String {
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

  private var parameter: [String: Any] {
    var defaultParams = ["api_key": Config.movieDBApiKey]
    switch self {
    case .search(let query) where query.count > 0:
      defaultParams["query"] = query
    case .detailMovie:
      defaultParams["append_to_response"] = "casts,videos"
    default:
      break
    }
    return defaultParams
  }
}
