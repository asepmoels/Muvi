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

  let isLoading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
  let error: BehaviorRelay<ApiError?> = BehaviorRelay.init(value: nil)
  let movie: BehaviorRelay<Movie?> = BehaviorRelay.init(value: nil)
  var movieId = ""

  init(detailUseCase: DetailMovieUseCase) {
    self.detailUseCase = detailUseCase
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
}
