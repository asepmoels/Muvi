//
//  MovieRepository.swift
//  Movies
//
//  Created by Asep Mulyana on 21/06/21.
//

import Foundation
import Core
import RxSwift

public struct MovieRepository<
  MovieDataSource: DataSource,
  LocalMovieDataSource: LocaleDataSource>: Repository
where
  MovieDataSource.Response == Movie,
  MovieDataSource.Request == Int {

  public typealias Request = Int
  public typealias Response = Movie

  private let disposeBag = DisposeBag()
  private let remoteDataSource: MovieDataSource
  private let localDataSource: LocalMovieDataSource

  public init(remoteDataSource: MovieDataSource,
              localDataSource: LocalMovieDataSource) {
    self.remoteDataSource = remoteDataSource
    self.localDataSource = localDataSource
  }

  public func execute(request: Int?) -> Observable<Movie> {
    let result = ReplaySubject<Movie>.createUnbounded()
    let saved = localDataSource.get(entityId: request ?? 0)
    remoteDataSource.execute(request: request)
      .subscribe(onNext: { movie in
        var newMovie = movie
        newMovie.isFavorite = saved != nil
        result.onNext(newMovie)
      }, onError: { (error) in
        result.onError(error)
      }, onCompleted: {
        result.onCompleted()
      })
      .disposed(by: disposeBag)
    return result
  }
}
