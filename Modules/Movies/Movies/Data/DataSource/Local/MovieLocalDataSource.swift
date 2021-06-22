//
//  MovieLocalDataSource.swift
//  Movies
//
//  Created by Asep Mulyana on 22/06/21.
//

import Foundation
import Core
import RxSwift
import RealmSwift

public struct MovieLocalDataSource: LocaleDataSource {
  public typealias Request = Movie
  public typealias Response = Movie

  private let realm: Realm? = try? Realm(
    configuration: Realm.Configuration.init(schemaVersion: 1)
  )

  public init() {}

  public func list(request: Movie?) -> Observable<[Movie]> {
    ReplaySubject<[Movie]>.createUnbounded()
  }

  public func add(entity: Movie) -> Observable<Movie> {
    let result = ReplaySubject<Movie>.createUnbounded()
    if let realm = realm,
       let object = entity as? MovieEntity {
      do {
        try realm.write {
          realm.add(object, update: .all)
        }
        object.isFavorite = true
        result.onNext(object)
        result.onCompleted()
      } catch {
        result.onError(error)
      }
    }
    return result
  }

  public func delete(entity: Movie) -> Observable<Movie> {
    let result = ReplaySubject<Movie>.createUnbounded()
    if let realm = realm,
       let object = savedMovie(with: entity.identifier) {
      do {
        try realm.write {
          realm.delete(object)
        }
        object.isFavorite = false
        result.onNext(object)
        result.onCompleted()
      } catch {
        result.onError(error)
      }
    }
    return result
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
