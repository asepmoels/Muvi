//
//  DetailMoviePresenter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import RxRelay
import RxSwift

class DetailMoviePresenter {
  private let disposeBag = DisposeBag()
  private let detailUseCase: DetailMovieUseCase
  private let addFavoriteUseCase: AddFavoriteUseCase
  private let removeFavoriteUseCase: RemoveFavoriteUseCase

  let isLoading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
  let error: BehaviorRelay<ApiError?> = BehaviorRelay.init(value: nil)
  let movie: BehaviorRelay<Movie?> = BehaviorRelay.init(value: nil)
  var movieId = ""

  var trailer: String? {
    let videos = movie.value?.videos
    return videos?
      .filter({ $0.site == "YouTube" })
      .sorted(by: { (left, right) -> Bool in
        if left.type == "Trailer" {
          return true
        } else if right.type == "Trailer" && left.type != "Trailer" {
          return false
        }
        return true
      })
      .first?.key
  }

  init(detailUseCase: DetailMovieUseCase,
       addFavoriteUseCase: AddFavoriteUseCase,
       removeFavoriteUseCase: RemoveFavoriteUseCase) {
    self.detailUseCase = detailUseCase
    self.addFavoriteUseCase = addFavoriteUseCase
    self.removeFavoriteUseCase = removeFavoriteUseCase
  }

  func getDetailMovie() {
    isLoading.accept(true)

    detailUseCase.getDetail(movieId: movieId).subscribe { [weak self] (genre) in
      self?.movie.accept(genre)
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

  func removeFromFavorite() {
    guard let item = movie.value else { return }
    removeFavoriteUseCase.removeFavorite(movie: item).subscribe { [weak self] (movie) in
      self?.movie.accept(movie)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
    }.disposed(by: disposeBag)
  }
}
