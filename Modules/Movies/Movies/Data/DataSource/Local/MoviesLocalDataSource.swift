//
//  MoviesLocalDataSource.swift
//  Movies
//
//  Created by Asep Mulyana on 21/06/21.
//

import Foundation
import Core
import RxSwift
import RealmSwift

public struct MoviesLocalDataSource: LocaleDataSource {
  public typealias Request = String
  public typealias Response = Movie

  private let realm: Realm? = try? Realm(
    configuration: Realm.Configuration.init(schemaVersion: 1)
  )

  public init() {}

  public func list(request: String?) -> Observable<[Movie]> {
    let result = ReplaySubject<[Movie]>.createUnbounded()
    let keyword = request ?? ""
    if let realm = realm {
      let all = realm.objects(MovieEntity.self)
        .sorted(byKeyPath: "title")
      var movies = [MovieEntity]()
      all.forEach { (movie) in
        if (!keyword.isEmpty &&
              movie.title.lowercased().contains(keyword.lowercased())) ||
            keyword.isEmpty {
          movies.append(movie)
        }
      }
      result.onNext(movies)
      result.onCompleted()
    } else {
      result.onNext([])
      result.onCompleted()
    }
    return result
  }

  public func add(entity: Movie) -> Observable<Movie> {
    ReplaySubject<Movie>.createUnbounded()
  }

  public func delete(entity: Movie) -> Observable<Movie> {
    ReplaySubject<Movie>.createUnbounded()
  }

  public func get(id: Int) -> Movie? {
    savedMovie(with: id)
  }

  private func savedMovie(with movieId: Int) -> MovieEntity? {
    let movie = realm?.object(ofType: MovieEntity.self, forPrimaryKey: movieId)
    return movie
  }

  public func isFavorited(movieId: Int) -> Bool {
    return savedMovie(with: movieId) != nil
  }
}
