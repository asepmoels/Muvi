//
//  LocalDataSource.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import RxSwift
import RealmSwift

protocol LocalDataSourceProtocol {
  func addFavorite(movie: Movie) -> Observable<Movie>
  func removeFavorite(movie: Movie) -> Observable<Movie>
  func getFavorites(keyword: String) -> Observable<[Movie]>
}

struct LocalDataSource: LocalDataSourceProtocol {
  private let realm: Realm?

  init(realm: Realm?) {
    self.realm = realm
  }

  func addFavorite(movie: Movie) -> Observable<Movie> {
    let result = PublishSubject<Movie>.init()
    if let realm = realm,
       let object = movie as? MovieEntity {
      do {
        try realm.write {
          realm.add(object)
          result.onNext(object)
        }
      } catch {
        result.onError(error)
      }
    }
    return result.asObservable()
  }

  func removeFavorite(movie: Movie) -> Observable<Movie> {
    let result = PublishSubject<Movie>.init()
    if let realm = realm,
       let object = movie as? MovieEntity {
      do {
        try realm.write {
          realm.delete(object)
          result.onNext(object)
        }
      } catch {
        result.onError(error)
      }
    }
    return result.asObservable()
  }

  func getFavorites(keyword: String) -> Observable<[Movie]> {
    let result = PublishSubject<[Movie]>.init()
    if let realm = realm {
      let all = realm.objects(MovieEntity.self)
        .sorted(byKeyPath: "title")
      var movies = [MovieEntity]()
      all.forEach { (movie) in
        movies.append(movie)
      }
      result.onNext(movies)
    } else {
      result.onNext([])
    }
    return result.asObservable()
  }
}
