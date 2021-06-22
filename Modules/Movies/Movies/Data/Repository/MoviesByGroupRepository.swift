//
//  MoviesByGroupRepository.swift
//  Movies
//
//  Created by Asep Mulyana on 22/06/21.
//

import Foundation
import Core
import RxSwift

public struct MoviesByGroupRepository<
  MovieDataSource: DataSource>: Repository
where
  MovieDataSource.Response == [Movie],
  MovieDataSource.Request == Int {

  public typealias Request = Int
  public typealias Response = [Movie]

  private let remoteDataSource: MovieDataSource

  public init(remoteDataSource: MovieDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  public func execute(request: Int?) -> Observable<[Movie]> {
    remoteDataSource.execute(request: request)
  }
}
