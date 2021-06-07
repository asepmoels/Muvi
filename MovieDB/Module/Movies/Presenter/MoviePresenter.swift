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
  case topRated = "Top Rated"
  case popular = "Popular"
  case upcoming = "Upcoming"
}

class MoviePresenter {
  private let disposeBag = DisposeBag()
  private let nowPlayingUseCase: NowPlayingUseCase
  private let popularUseCase: PopularUseCase
  private let topRatedUseCase: TopRatedUseCase
  private let  upcomingUseCase: UpcomingUseCase

  let isLoading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
  let error: BehaviorRelay<ApiError?> = BehaviorRelay.init(value: nil)
  let nowPlayings: BehaviorRelay<[Movie]?> = BehaviorRelay.init(value: nil)
  let populars: BehaviorRelay<[Movie]?> = BehaviorRelay.init(value: nil)
  let topRateds: BehaviorRelay<[Movie]?> = BehaviorRelay.init(value: nil)
  let upcomings: BehaviorRelay<[Movie]?> = BehaviorRelay.init(value: nil)
  let homeContents = HomeContent.allCases

  init(nowPlayingUseCase: NowPlayingUseCase,
       popularUseCase: PopularUseCase,
       topRatedUseCase: TopRatedUseCase,
       upcomingUseCase: UpcomingUseCase) {
    self.nowPlayingUseCase = nowPlayingUseCase
    self.popularUseCase = popularUseCase
    self.topRatedUseCase = topRatedUseCase
    self.upcomingUseCase = upcomingUseCase
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

  func getPopular() {
    isLoading.accept(true)

    popularUseCase.getPopular().subscribe { [weak self] (genre) in
      self?.populars.accept(genre)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
      self?.isLoading.accept(false)
    } onCompleted: { [weak self] in
      self?.isLoading.accept(false)
    }.disposed(by: disposeBag)
  }

  func getTopRated() {
    isLoading.accept(true)

    topRatedUseCase.getTopRated().subscribe { [weak self] (genre) in
      self?.topRateds.accept(genre)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
      self?.isLoading.accept(false)
    } onCompleted: { [weak self] in
      self?.isLoading.accept(false)
    }.disposed(by: disposeBag)
  }

  func getUpcoming() {
    isLoading.accept(true)

    upcomingUseCase.getUpcoming().subscribe { [weak self] (genre) in
      self?.upcomings.accept(genre)
    } onError: { [weak self] (error) in
      self?.error.accept(error as? ApiError)
      self?.isLoading.accept(false)
    } onCompleted: { [weak self] in
      self?.isLoading.accept(false)
    }.disposed(by: disposeBag)
  }
}
