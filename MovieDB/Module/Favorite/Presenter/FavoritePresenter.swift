//
//  FavoritePresenter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import RxRelay
import RxSwift

class FavoritePresenter {
  private let disposeBag = DisposeBag()
  private let favoriteUseCase: FavoriteMovieUseCase
  private let addFavoriteUseCase: AddFavoriteUseCase
  private let removeFavoriteUseCase: RemoveFavoriteUseCase

  let isLoading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
  let error: BehaviorRelay<ApiError?> = BehaviorRelay.init(value: nil)
  let movie: BehaviorRelay<Movie?> = BehaviorRelay.init(value: nil)
  let movies: BehaviorRelay<[Movie]?> = BehaviorRelay.init(value: nil)

  init(favoriteUseCase: FavoriteMovieUseCase,
       addFavoriteUseCase: AddFavoriteUseCase,
       removeFavoriteUseCase: RemoveFavoriteUseCase) {
    self.favoriteUseCase = favoriteUseCase
    self.addFavoriteUseCase = addFavoriteUseCase
    self.removeFavoriteUseCase = removeFavoriteUseCase
  }

  func getFavoriteMovies(keyword: String) {
    isLoading.accept(true)

    favoriteUseCase.getFavorite(keyword: keyword).subscribe { [weak self] (movies) in
      self?.movies.accept(movies)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
      self?.isLoading.accept(false)
    } onCompleted: { [weak self] in
      self?.isLoading.accept(false)
    }.disposed(by: disposeBag)
  }

  func addToFavorite() {
    guard let item = movie.value else { return }
    addFavoriteUseCase.addFavorite(movie: item).subscribe { [weak self] (movie) in
      self?.movie.accept(movie)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
    }.disposed(by: disposeBag)
  }

  func removeFromFavorite(item: Movie) {
    removeFavoriteUseCase.removeFavorite(movie: item).subscribe { [weak self] (movie) in
      self?.movie.accept(movie)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
    }.disposed(by: disposeBag)
  }
}
