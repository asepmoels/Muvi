//
//  MovieDBTests.swift
//  MovieDBTests
//
//  Created by Asep Mulyana on 07/06/21.
//

import XCTest
@testable import MovieDB
import RxBlocking
import RxSwift
import Swinject

class MovieDBTests: XCTestCase {
  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func testNowPlayingUseCase() throws {
    let useCase: NowPlayingUseCase = TestInjection().resolve()
    let stream = useCase.getNowPlaying()
    let result = try? stream.toBlocking().last()

    XCTAssertEqual(result?.count, 2)
    XCTAssertEqual(result?.compactMap({ $0.title }), ["Now You See Me", "Ironman 3"])
  }

  func testTrendingUseCase() throws {
    let useCase: TrendingUseCase = TestInjection().resolve()
    let stream = useCase.getTrending()
    let result = try? stream.toBlocking().last()

    XCTAssertEqual(result?.count, 2)
    XCTAssertEqual(result?.compactMap({ $0.title }), ["Now You See Me", "Ironman 3"])
  }

  func testSearchMovieUseCase() throws {
    let useCase: SearchMovieUseCase = TestInjection().resolve()
    let stream = useCase.searchMovie(keyword: "you")
    let result = try? stream.toBlocking().last()

    XCTAssertEqual(result?.count, 2)
    XCTAssertEqual(result?.compactMap({ $0.title }), ["Now You See Me", "Ironman 3"])
  }

  func testDetailMovieUseCase() throws {
    let useCase: DetailMovieUseCase = TestInjection().resolve()
    let stream = useCase.getDetail(movieId: "10")
    let result = try? stream.toBlocking().last()

    XCTAssertEqual(result?.title, "Now You See Me")
    XCTAssertEqual(result?.identifier, 10)
  }
}

class TestInjection: Injection {
  private let container = Container()

  override init() {
    super.init()
    container.register(RemoteDataSourceProtocol.self) { (_) in
      DummyRemoteDataSource()
    }
  }

  override func resolve<T>() -> T {
    if T.self == RemoteDataSourceProtocol.self {
      guard let result = container.resolve(T.self) else {
        fatalError("This type is not registered: \(T.self)")
      }
      return result
    }
    return super.resolve()
  }
}
