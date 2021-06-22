//
//  MoviesRemoteDataSource.swift
//  Movies
//
//  Created by Asep Mulyana on 21/06/21.
//

import Foundation
import Core
import RxSwift
import RxRelay

public struct MoviesRemoteDataSource: DataSource {
  public typealias Request = Int
  public typealias Response = [Movie]

  private let dispose = DisposeBag()

  public init(){}

  public func execute(request: Int?) -> Observable<[Movie]> {
    let api: API
    switch request ?? 0 {
    case 0:
      api = API.trending
    case 1:
      api = .nowPlaying
    case 2:
      api = .topRated
    case 3:
      api = .popular
    default:
      api = .upcoming
    }

    let result = ReplayRelay<[Movie]>.createUnbound()

    NetworkService.shared.connect(
      api: api.url,
      responseType: MovieResponse.self
    )
    .map({ $0.results ?? [] })
    .bind(to: result)
    .disposed(by: dispose)
    
    return result.asObservable()
  }
}
