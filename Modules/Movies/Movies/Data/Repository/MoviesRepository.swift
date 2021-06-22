//
//  MoviesRepository.swift
//  Movies
//
//  Created by Asep Mulyana on 21/06/21.
//

import Foundation
import Core
import RxSwift

public struct MoviesRepository<
  MovieDataSource: DataSource>: Repository
where
  MovieDataSource.Response == [Movie],
  MovieDataSource.Request == String {

  public typealias Request = String
  public typealias Response = [Movie]

  private let remoteDataSource: MovieDataSource

  public init(remoteDataSource: MovieDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  public func execute(request: String?) -> Observable<[Movie]> {
    remoteDataSource.execute(request: request)
  }
}
