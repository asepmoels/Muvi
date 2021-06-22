//
//  DumySearchRemoteDataSource.swift
//  MovieDBTests
//
//  Created by Asep Mulyana on 22/06/21.
//

import RxSwift
@testable import MovieDB
@testable import Core
@testable import Movies

struct DumySearchRemoteDataSource: DataSource {
  typealias Request = String
  typealias Response = [Movie]

  func execute(request: String?) -> Observable<[Movie]> {
    createDummyArrayResponse(query: request)
  }

  private func createDummyArrayResponse(query: String?) -> Observable<[Movie]> {
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
}
