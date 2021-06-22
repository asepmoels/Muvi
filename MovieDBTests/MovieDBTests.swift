//
//  MovieDBTests.swift
//  MovieDBTests
//
//  Created by Asep Mulyana on 07/06/21.
//

import XCTest
@testable import MovieDB
@testable import Movies
@testable import Core
import RxBlocking
import RxSwift
import Swinject

typealias DummyInteractorType = Interactor<
  Int, [Movie], MoviesByGroupRepository<
    DummyRemoteDataSource
  >
>

class MovieDBTests: XCTestCase {
  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func testTrendingUseCase() throws {
    let useCase: DummyInteractorType = TestInjection().resolve()
    let stream = useCase.execute(request: 0)
    let result = try? stream.toBlocking().last()

    XCTAssertEqual(result?.count, 2)
    XCTAssertEqual(result?.compactMap({ $0.title }), ["Now You See Me", "Ironman 3"])
  }
}

class TestInjection: Injection {
  private let container = Container()

  override init() {
    super.init()
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

  override func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      return super.resolve()
    }
    return result
  }
}
