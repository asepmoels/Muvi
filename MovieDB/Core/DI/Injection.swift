//
//  Injection.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import Swinject

struct Injection {
  static let shared = Injection()
  private let container = Container()

  init() {
    container.register(HomeRouter.self, factory: { _ in
      HomeRouter()
    })

    container.register(HomeTabViewController.self) { _ in
      HomeTabViewController(router: Injection.shared.resolve())
    }

    container.register(MoviesViewController.self) { _ in
      MoviesViewController(presenter: Injection.shared.resolve())
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
      MovieRepository(remoteDataSource: Injection.shared.resolve())
    }

    container.register(RemoteDataSourceProtocol.self) { _ in
      RemoteDataSource()
    }
  }

  func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
