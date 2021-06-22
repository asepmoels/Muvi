//
//  TestInjection.swift
//  MovieDBTests
//
//  Created by Asep Mulyana on 22/06/21.
//

@testable import MovieDB
@testable import Movies
@testable import Core
import Swinject

class TestInjection: Injection {
  private let container = Container()

  override init() {
    super.init()
    registerDummyDataSource()
    registerDummySearchDataSource()
  }

  private func registerDummyDataSource() {
    container.register(DummyInteractorType.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(MoviesByGroupRepository<DummyRemoteDataSource>.self) { [unowned self] _ in
      MoviesByGroupRepository(remoteDataSource: self.resolve())
    }
    container.register(DummyRemoteDataSource.self) { _ in
      DummyRemoteDataSource()
    }
  }

  private func registerDummySearchDataSource() {
    container.register(DummySearchInteractorType.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(MoviesRepository<DumySearchRemoteDataSource>.self) { [unowned self] _ in
      MoviesRepository(remoteDataSource: self.resolve())
    }
    container.register(DumySearchRemoteDataSource.self) { _ in
      DumySearchRemoteDataSource()
    }
  }

  override func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      return super.resolve()
    }
    return result
  }
}
