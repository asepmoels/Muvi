//
//  MovieRepository.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

struct MovieRepository: MovieRepositoryProtocol {
  private let remoteDataSource: RemoteDataSourceProtocol
  private let localDataSource: LocalDataSourceProtocol

  init(remoteDataSource: RemoteDataSourceProtocol,
       localDataSource: LocalDataSourceProtocol) {
    self.remoteDataSource = remoteDataSource
    self.localDataSource = localDataSource
  }

  func getNowPlaying() -> Observable<[Movie]> {
    remoteDataSource.getNowPlaying()
  }

  func getPopular() -> Observable<[Movie]> {
    remoteDataSource.getPopular()
  }

  func getTopRated() -> Observable<[Movie]> {
    remoteDataSource.getTopRated()
  }

  func getUpcoming() -> Observable<[Movie]> {
    remoteDataSource.getUpcoming()
  }

  func getTrending() -> Observable<[Movie]> {
    remoteDataSource.getTrending()
  }

  func searchMovie(keyword: String) -> Observable<[Movie]> {
    remoteDataSource.searchMovie(keyword: keyword)
  }

  func addFavorite(movie: Movie) -> Observable<Movie> {
    localDataSource.addFavorite(movie: movie)
  }

  func removeFavorite(movie: Movie) -> Observable<Movie> {
    localDataSource.removeFavorite(movie: movie)
  }

  func getFavorites(keyword: String) -> Observable<[Movie]> {
    localDataSource.getFavorites(keyword: keyword)
  }

  func getDetailMovie(movieId: String) -> Observable<Movie> {
    let movieID = Int(movieId) ?? 0
    let isFavorited = localDataSource.isFavorited(movieId: movieID)
    return remoteDataSource.getDetail(movieId: movieId)
      .map { (item) -> Movie in
        var modified = item
        modified.isFavorite = isFavorited
        return modified
      }
  }
}
