//
//  FavoriteMoviesRepository.swift
//  Movies
//
//  Created by Asep Mulyana on 21/06/21.
//

import Foundation
import Core
import RxSwift

public struct FavoriteMoviesRepository<
  MovieDataSource: LocaleDataSource>: Repository
where
  MovieDataSource.Response == Movie,
  MovieDataSource.Request == String {

  public typealias Request = String
  public typealias Response = [Movie]

  private let localDataSource: MovieDataSource

  public init(localDataSource: MovieDataSource) {
    self.localDataSource = localDataSource
  }

  public func execute(request: String?) -> Observable<[Movie]> {
    localDataSource.list(request: request)
  }
}
