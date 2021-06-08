//
//  RemoteDataSource.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol RemoteDataSourceProtocol {
  func getNowPlaying() -> Observable<[Movie]>
  func getPopular() -> Observable<[Movie]>
  func getTopRated() -> Observable<[Movie]>
  func getUpcoming() -> Observable<[Movie]>
  func getTrending() -> Observable<[Movie]>
  func searchMovie(keyword: String) -> Observable<[Movie]>
  func getDetail(movieId: String) -> Observable<Movie>
}

struct RemoteDataSource: RemoteDataSourceProtocol {
  func getNowPlaying() -> Observable<[Movie]> {
    NetworkService.shared
      .connect(api: .nowPlaying, responseType: MovieResponse.self)
      .compactMap({ $0.results })
  }

  func getPopular() -> Observable<[Movie]> {
    NetworkService.shared
      .connect(api: .popular, responseType: MovieResponse.self)
      .compactMap({ $0.results })
  }

  func getTopRated() -> Observable<[Movie]> {
    NetworkService.shared
      .connect(api: .topRated, responseType: MovieResponse.self)
      .compactMap({ $0.results })
  }

  func getUpcoming() -> Observable<[Movie]> {
    NetworkService.shared
      .connect(api: .upcoming, responseType: MovieResponse.self)
      .compactMap({ $0.results })
  }

  func getTrending() -> Observable<[Movie]> {
    NetworkService.shared
      .connect(api: .trending, responseType: MovieResponse.self)
      .compactMap({ $0.results })
  }

  func searchMovie(keyword: String) -> Observable<[Movie]> {
    NetworkService.shared
      .connect(api: .search(query: keyword), responseType: MovieResponse.self)
      .compactMap({ $0.results })
  }

  func getDetail(movieId: String) -> Observable<Movie> {
    NetworkService.shared
      .connect(api: .detailMovie(movieId: movieId), responseType: MovieEntity.self)
      .compactMap({ $0 })
  }
}
