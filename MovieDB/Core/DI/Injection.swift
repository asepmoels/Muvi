//
//  Injection.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import Swinject
import RealmSwift

struct Injection {
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
    container.register(HomeTabViewController.self) { _ in
      HomeTabViewController(router: Injection.shared.resolve())
    }
  }

  private func registerMovieFeature() {
    container.register(MoviesViewController.self) { _ in
      MoviesViewController(router: Injection.shared.resolve(),
                           presenter: Injection.shared.resolve())
    }
    container.register(MovieRouter.self) { _ in
      MovieRouter()
    }
    container.register(MoviePresenter.self) { _ in
      MoviePresenter(nowPlayingUseCase: Injection.shared.resolve(),
                     popularUseCase: Injection.shared.resolve(),
                     topRatedUseCase: Injection.shared.resolve(),
                     upcomingUseCase: Injection.shared.resolve(),
                     trendingUseCase: Injection.shared.resolve())
    }
    container.register(NowPlayingUseCase.self) { _ in
      NowPlayingInteractor(repository: Injection.shared.resolve())
    }
    container.register(PopularUseCase.self) { _ in
      PopularInteractor(repository: Injection.shared.resolve())
    }
    container.register(TopRatedUseCase.self) { _ in
      TopRatedInteractor(repository: Injection.shared.resolve())
    }
    container.register(UpcomingUseCase.self) { _ in
      UpcomingInteractor(repository: Injection.shared.resolve())
    }
    container.register(TrendingUseCase.self) { _ in
      TrendingInteractor(repository: Injection.shared.resolve())
    }
    container.register(MovieRepositoryProtocol.self) { _ in
      MovieRepository(remoteDataSource: Injection.shared.resolve(),
                      localDataSource: Injection.shared.resolve())
    }
  }

  private func registerSearchFeature() {
    container.register(SearchViewController.self) { _ in
      SearchViewController(router: Injection.shared.resolve(),
                           presenter: Injection.shared.resolve())
    }
    container.register(SearchPresenter.self) { _ in
      SearchPresenter(searchUseCase: Injection.shared.resolve())
    }
    container.register(SearchMovieUseCase.self) { _ in
      SearchMovieInteractor(repository: Injection.shared.resolve())
    }
  }

  private func registerAboutFeature() {
    container.register(AboutViewController.self) { _ in
      AboutViewController()
    }
  }

  private func registerDetailFeature() {
    container.register(DetailMovieViewController.self) { _ in
      DetailMovieViewController(presenter: Injection.shared.resolve())
    }
    container.register(DetailMoviePresenter.self) { _ in
      DetailMoviePresenter(detailUseCase: Injection.shared.resolve(),
                           addFavoriteUseCase: Injection.shared.resolve(),
                           removeFavoriteUseCase: Injection.shared.resolve())
    }
    container.register(DetailMovieRouter.self) { _ in
      DetailMovieRouter()
    }
    container.register(DetailMovieUseCase.self) { _ in
      DetailMovieInteractor(repository: Injection.shared.resolve())
    }
  }

  private func registerFavoriteFeature() {
    container.register(AddFavoriteUseCase.self) { _ in
      AddFavoriteInteractor(repository: Injection.shared.resolve())
    }
    container.register(RemoveFavoriteUseCase.self) { _ in
      RemoveFavoriteInteractor(repository: Injection.shared.resolve())
    }
    container.register(FavoriteMovieUseCase.self) { _ in
      FavoriteMovieInteractor(repository: Injection.shared.resolve())
    }
  }

  func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
