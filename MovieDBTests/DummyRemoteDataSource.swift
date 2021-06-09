//
//  DummyRemoteDataSource.swift
//  MovieDBTests
//
//  Created by Asep Mulyana on 09/06/21.
//

import RxSwift
@testable import MovieDB

struct DummyRemoteDataSource: RemoteDataSourceProtocol {
  private func createDummyArrayResponse() -> Observable<[Movie]> {
    let result = ReplaySubject<[MovieEntity]>.createUnbounded()
    let objects = [
      [
        "id": 10,
        "title": "Now You See Me"
      ],
      [
        "id": 100,
        "title": "Ironman 3"
      ]
    ].compactMap({ MovieEntity(JSON: $0) })
    result.onNext(objects)
    result.onCompleted()
    return result.compactMap({ $0 })
  }

  private func createDummySingleResponse() -> Observable<Movie> {
    let result = ReplaySubject<MovieEntity>.createUnbounded()
    let json = [
      "id": 10,
      "title": "Now You See Me"
    ] as [String: Any]
    if let object = MovieEntity(JSON: json) {
      result.onNext(object)
    }
    result.onCompleted()
    return result.compactMap({ $0 })
  }

  func getNowPlaying() -> Observable<[Movie]> {
    createDummyArrayResponse()
  }

  func getPopular() -> Observable<[Movie]> {
    createDummyArrayResponse()
  }

  func getTopRated() -> Observable<[Movie]> {
    createDummyArrayResponse()
  }

  func getUpcoming() -> Observable<[Movie]> {
    createDummyArrayResponse()
  }

  func getTrending() -> Observable<[Movie]> {
    createDummyArrayResponse()
  }

  func searchMovie(keyword: String) -> Observable<[Movie]> {
    createDummyArrayResponse()
  }

  func getDetail(movieId: String) -> Observable<Movie> {
    createDummySingleResponse()
  }
}
