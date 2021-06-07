//
//  SearchPresenter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxRelay
import RxSwift

class SearchPresenter {
  private let disposeBag = DisposeBag()
  private let searchUseCase: SearchMovieUseCase

  let isLoading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
  let error: BehaviorRelay<ApiError?> = BehaviorRelay.init(value: nil)
  let movies: BehaviorRelay<[Movie]?> = BehaviorRelay.init(value: nil)
  let homeContents = HomeContent.allCases

  init(searchUseCase: SearchMovieUseCase) {
    self.searchUseCase = searchUseCase
  }

  func searchMovies(keyword: String) {
    if keyword.isEmpty {
      movies.accept(nil)
      return
    }

    isLoading.accept(true)

    searchUseCase.searchMovie(keyword: keyword).subscribe { [weak self] (genre) in
      self?.movies.accept(genre)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
      self?.isLoading.accept(false)
    } onCompleted: { [weak self] in
      self?.isLoading.accept(false)
    }.disposed(by: disposeBag)
  }
}
