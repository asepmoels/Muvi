//
//  MovieRemoteDataSource.swift
//  Movies
//
//  Created by Asep Mulyana on 21/06/21.
//

import Foundation
import Core
import RxSwift
import RxRelay

public struct MovieRemoteDataSource: DataSource {
  public typealias Request = Int
  public typealias Response = Movie

  private let disposeBag = DisposeBag()

  public init(){ }

  public func execute(request: Int?) -> Observable<Movie> {
    NetworkService.shared.connect(
      api: API.detailMovie(movieId: "\(request ?? 0)").url,
      responseType: MovieEntity.self
    )
    .map({ $0 })
  }
}
