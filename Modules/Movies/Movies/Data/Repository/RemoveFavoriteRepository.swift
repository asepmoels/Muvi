//
//  RemoveFavoriteRepository.swift
//  Movies
//
//  Created by Asep Mulyana on 22/06/21.
//

import Foundation
import Core
import RxSwift

public struct RemoveFavoriteRepository<
  MovieDataSource: LocaleDataSource>: Repository
where
  MovieDataSource.Response == Movie,
  MovieDataSource.Request == Movie {

  public typealias Request = Movie
  public typealias Response = Movie

  private let localDataSource: MovieDataSource

  public init(localDataSource: MovieDataSource) {
    self.localDataSource = localDataSource
  }

  public func execute(request: Movie?) -> Observable<Movie> {
    if let movie = request {
      return localDataSource.delete(entity: movie)
    }
    return ReplaySubject<Movie>.createUnbounded()
  }
}
