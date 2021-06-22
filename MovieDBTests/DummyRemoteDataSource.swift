//
//  DummyRemoteDataSource.swift
//  MovieDBTests
//
//  Created by Asep Mulyana on 09/06/21.
//

import RxSwift
@testable import MovieDB
@testable import Core
@testable import Movies

enum NetworkError: Error {
  case internalServerError
}

struct DummyRemoteDataSource: DataSource {
  typealias Request = Int
  typealias Response = [Movie]

  func execute(request: Int?) -> Observable<[Movie]> {
    if request == 10 {
      return createErrorResponse()
    }

    return createDummyArrayResponse()
  }

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

  private func createErrorResponse() -> Observable<[Movie]> {
    let result = ReplaySubject<[MovieEntity]>.createUnbounded()
    result.onError(ApiError.networkFailure(error: NetworkError.internalServerError))
    return result.compactMap({ $0 })
  }
}
