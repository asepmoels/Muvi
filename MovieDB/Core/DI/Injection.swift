//
//  Injection.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import Swinject
import RealmSwift

class Injection {
  static let shared = Injection()
  private let container = Container()

  let realm: Realm? = try? Realm(
    configuration: Realm.Configuration.init(schemaVersion: 1)
  )

  init() {
    registerHomeFeature()
    registerMovieFeature()
    registerSearchFeature()
    registerAboutFeature()
    registerDetailFeature()
    registerFavoriteFeature()

    container.register(RemoteDataSourceProtocol.self) { _ in
      RemoteDataSource()
    }
    container.register(LocalDataSourceProtocol.self) { _ in
      return LocalDataSource(realm: Injection.shared.realm)
    }
  }

  private func registerHomeFeature() {
    container.register(HomeRouter.self, factory: { _ in
      HomeRouter()
    })
    container.register(HomeTabViewController.self) { [unowned self] _ in
      HomeTabViewController(router: self.resolve())
    }
  }

  private func registerMovieFeature() {
    container.register(MoviesViewController.self) { [unowned self] _ in
      MoviesViewController(router: self.resolve(),
                           presenter: self.resolve())
    }
    container.register(MovieRouter.self) { _ in
      MovieRouter()
    }
    container.register(MoviePresenter.self) { [unowned self] _ in
      MoviePresenter(nowPlayingUseCase: self.resolve(),
                     popularUseCase: self.resolve(),
                     topRatedUseCase: self.resolve(),
                     upcomingUseCase: self.resolve(),
                     trendingUseCase: self.resolve())
    }
    container.register(NowPlayingUseCase.self) { [unowned self] _ in
      NowPlayingInteractor(repository: self.resolve())
    }
    container.register(PopularUseCase.self) { [unowned self] _ in
      PopularInteractor(repository: self.resolve())
    }
    container.register(TopRatedUseCase.self) { [unowned self] _ in
      TopRatedInteractor(repository: self.resolve())
    }
    container.register(UpcomingUseCase.self) { [unowned self] _ in
      UpcomingInteractor(repository: self.resolve())
    }
    container.register(TrendingUseCase.self) { [unowned self] _ in
      TrendingInteractor(repository: self.resolve())
    }
    container.register(MovieRepositoryProtocol.self) { [unowned self] _ in
      MovieRepository(remoteDataSource: self.resolve(),
                      localDataSource: self.resolve())
    }
  }

  private func registerSearchFeature() {
    container.register(SearchViewController.self) { [unowned self] _ in
      SearchViewController(router: self.resolve(),
                           presenter: self.resolve())
    }
    container.register(SearchPresenter.self) { [unowned self] _ in
      SearchPresenter(searchUseCase: self.resolve())
    }
    container.register(SearchMovieUseCase.self) { [unowned self] _ in
      SearchMovieInteractor(repository: self.resolve())
    }
  }

  private func registerAboutFeature() {
    container.register(AboutViewController.self) { _ in
      AboutViewController()
    }
  }

  private func registerDetailFeature() {
    container.register(DetailMovieViewController.self) { [unowned self] _ in
      DetailMovieViewController(router: self.resolve(),
                                presenter: self.resolve())
    }
    container.register(DetailMoviePresenter.self) { [unowned self] _ in
      DetailMoviePresenter(detailUseCase: self.resolve(),
                           addFavoriteUseCase: self.resolve(),
                           removeFavoriteUseCase: self.resolve())
    }
    container.register(DetailMovieRouter.self) { _ in
      DetailMovieRouter()
    }
    container.register(DetailMovieUseCase.self) { [unowned self] _ in
      DetailMovieInteractor(repository: self.resolve())
    }
    container.register(YoutubePlayerViewController.self) { _, videoId in
      YoutubePlayerViewController(videoId: videoId)
    }
  }

  private func registerFavoriteFeature() {
    container.register(AddFavoriteUseCase.self) { [unowned self] _ in
      AddFavoriteInteractor(repository: self.resolve())
    }
    container.register(RemoveFavoriteUseCase.self) { [unowned self] _ in
      RemoveFavoriteInteractor(repository: self.resolve())
    }
    container.register(FavoriteMovieUseCase.self) { [unowned self] _ in
      FavoriteMovieInteractor(repository: self.resolve())
    }
    container.register(FavoriteViewController.self) { [unowned self] _ in
      FavoriteViewController(router: self.resolve(),
                             presenter: self.resolve())
    }
    container.register(FavoritePresenter.self) { [unowned self] _ in
      FavoritePresenter(favoriteUseCase: self.resolve(),
                        addFavoriteUseCase: self.resolve(),
                        removeFavoriteUseCase: self.resolve())
    }
  }

  func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }

  func resolve<T, A>(argument: A) -> T {
    guard let result = container.resolve(T.self, argument: argument) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
