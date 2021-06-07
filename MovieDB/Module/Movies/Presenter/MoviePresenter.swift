//
//  MoviePresenter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxRelay
import RxSwift

enum HomeContent: String, CaseIterable {
  case nowPlaying = "Now Playing"
}

class MoviePresenter {
  private let disposeBag = DisposeBag()
  private let nowPlayingUseCase: NowPlayingUseCase

  let isLoading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
  let error: BehaviorRelay<ApiError?> = BehaviorRelay.init(value: nil)
  let nowPlayings: BehaviorRelay<[Movie]?> = BehaviorRelay.init(value: nil)
  let homeContents = HomeContent.allCases

  init(nowPlayingUseCase: NowPlayingUseCase) {
    self.nowPlayingUseCase = nowPlayingUseCase
  }

  func getNowPlaying() {
    isLoading.accept(true)

    nowPlayingUseCase.getNowPlaying().subscribe { [weak self] (genre) in
      self?.nowPlayings.accept(genre)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
      self?.isLoading.accept(false)
    } onCompleted: { [weak self] in
      self?.isLoading.accept(false)
    }.disposed(by: disposeBag)
  }
}
