//
//  SearchMoviesRemoteDataSource.swift
//  Movies
//
//  Created by Asep Mulyana on 21/06/21.
//

import Foundation
import Core
import RxSwift
import RxRelay

public struct SearchMoviesRemoteDataSource: DataSource {
  public typealias Request = String
  public typealias Response = [Movie]

  private let disposeBag = DisposeBag()

  public init() {}

  public func execute(request: String?) -> Observable<[Movie]> {
    let result = ReplayRelay<[Movie]>.createUnbound()

    NetworkService.shared.connect(
      api: API.search(query: request ?? "").url,
      responseType: MovieResponse.self
    )
    .map({ $0.results ?? [] })
    .bind(to: result)
    .disposed(by: disposeBag)

    return result.asObservable()
  }
}
