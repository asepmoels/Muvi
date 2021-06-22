//
//  Injection.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import Swinject
import Core
import Movies

class Injection {
  static let shared = Injection()
  private let container = Container()

  init() {
    registerHomeFeature()
    registerMovieFeature()
    registerSearchFeature()
    registerAboutFeature()
    registerDetailFeature()
    registerFavoriteFeature()
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
      return MoviesViewController(
        router: self.resolve(),
        presenters: [
          self.resolve(name: "presenter0"),
          self.resolve(name: "presenter1"),
          self.resolve(name: "presenter2"),
          self.resolve(name: "presenter3"),
          self.resolve(name: "presenter4")
        ])
    }
    container.register(MoviesPresenterType.self, name: "presenter0") { [unowned self] _ in
      GetGoupedListPresenter(useCase: self.resolve(), group: 0)
    }
    container.register(MoviesPresenterType.self, name: "presenter1") { [unowned self] _ in
      GetGoupedListPresenter(useCase: self.resolve(), group: 1)
    }
    container.register(MoviesPresenterType.self, name: "presenter2") { [unowned self] _ in
      GetGoupedListPresenter(useCase: self.resolve(), group: 2)
    }
    container.register(MoviesPresenterType.self, name: "presenter3") { [unowned self] _ in
      GetGoupedListPresenter(useCase: self.resolve(), group: 3)
    }
    container.register(MoviesPresenterType.self, name: "presenter4") { [unowned self] _ in
      GetGoupedListPresenter(useCase: self.resolve(), group: 4)
    }
    container.register(
      Interactor<
        Int, [Movie], MoviesByGroupRepository<
          MoviesRemoteDataSource
        >
      >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(MoviesByGroupRepository<MoviesRemoteDataSource>.self) { [unowned self] _ in
      MoviesByGroupRepository(remoteDataSource: self.resolve())
    }
    container.register(MoviesRemoteDataSource.self) { _ in
      MoviesRemoteDataSource()
    }
  }

  private func registerSearchFeature() {
    container.register(SearchViewController.self) { [unowned self] _ in
      SearchViewController(
        router: self.resolve(),
        presenter: self.resolve()
      )
    }
    container.register(SearchPresenterType.self) { [unowned self] _ in
      GetListPresenter(useCase: self.resolve())
    }
    container.register(
      Interactor<
        String, [Movie], MoviesRepository<
          SearchMoviesRemoteDataSource
        >
      >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(MoviesRepository<SearchMoviesRemoteDataSource>.self) { [unowned self] _ in
      MoviesRepository(remoteDataSource: self.resolve())
    }
    container.register(SearchMoviesRemoteDataSource.self) { _ in
      SearchMoviesRemoteDataSource()
    }
  }

  private func registerAboutFeature() {
    container.register(AboutViewController.self) { _ in
      AboutViewController()
    }
  }

  private func registerDetailFeature() {
    container.register(DetailMovieViewController.self) { [unowned self] _ in
      DetailMovieViewController(
        router: self.resolve(),
        detailPresenter: self.resolve(),
        addFavoritePresenter: self.resolve(),
        removeFavoritePresenter: self.resolve()
      )
    }
    container.register(DetailMovieRouter.self) { _ in
      DetailMovieRouter()
    }
    container.register(DetailMoviePresenterType.self) { [unowned self] _ in
      GetItemPresenter(useCase: self.resolve())
    }
    container.register(
      Interactor<
        Int, Movie, MovieRepository<
          MovieRemoteDataSource, MoviesLocalDataSource
        >
      >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(
      MovieRepository<MovieRemoteDataSource, MoviesLocalDataSource>.self
    ) { [unowned self] _ in
      MovieRepository(remoteDataSource: self.resolve(),
                      localDataSource: self.resolve())
    }
    container.register(MovieRemoteDataSource.self) { _ in
      MovieRemoteDataSource()
    }
    container.register(YoutubePlayerViewController.self) { _, videoId in
      YoutubePlayerViewController(videoId: videoId)
    }
  }

  private func registerFavoriteFeature() {
    container.register(AddFavoritePresenterType.self) { [unowned self] _ in
      GetItemPresenter(useCase: self.resolve())
    }
    container.register(
      Interactor<Movie, Movie, AddFavoriteRepository<MovieLocalDataSource>>.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(
      AddFavoriteRepository<MovieLocalDataSource>.self
    ) { [unowned self] _ in
      AddFavoriteRepository(localDataSource: self.resolve())
    }
    container.register(RemoveFavoritePresenterType.self) { [unowned self] _ in
      GetItemPresenter(useCase: self.resolve())
    }
    container.register(
      Interactor<Movie, Movie, RemoveFavoriteRepository<
                  MovieLocalDataSource>>.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(
      RemoveFavoriteRepository<MovieLocalDataSource>.self
    ) { [unowned self] _ in
      RemoveFavoriteRepository(localDataSource: self.resolve())
    }
    container.register(MovieLocalDataSource.self) { _ in
      MovieLocalDataSource()
    }
    container.register(FavoriteViewController.self) { [unowned self] _ in
      FavoriteViewController(
        router: self.resolve(),
        favoritePresenter: self.resolve(),
        removeFavoritePresenter: self.resolve())
    }
    container.register(FavoritePresenterType.self) { [unowned self] _ in
      GetListPresenter(useCase: self.resolve())
    }
    container.register(
      Interactor<String, [Movie], FavoriteMoviesRepository<
                  MoviesLocalDataSource>>.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(
      FavoriteMoviesRepository<MoviesLocalDataSource>.self
    ) { [unowned self] _ in
      FavoriteMoviesRepository(localDataSource: self.resolve())
    }
    container.register(MoviesLocalDataSource.self) { _ in
      MoviesLocalDataSource()
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
  func resolve<T>(name: String) -> T {
    guard let result = container.resolve(T.self, name: name) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
