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

typealias DummyInteractorType = Interactor<
  Int, [Movie], MoviesByGroupRepository<
    DummyRemoteDataSource
  >
>

typealias DummySearchInteractorType = Interactor<
  String, [Movie], MoviesRepository<
    DumySearchRemoteDataSource
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

  func testNetworkError() throws {
    let useCase: DummyInteractorType = TestInjection().resolve()
    let stream = useCase.execute(request: 10)

    XCTAssertThrowsError(try stream.toBlocking().last()) { error in
      guard let theError = error as? ApiError,
            case ApiError.networkFailure(let netError) = theError,
            let serverError = netError as? NetworkError else {
        XCTAssert(false)
        return
      }
      XCTAssertEqual(serverError, NetworkError.internalServerError)
    }
  }

  func testSearchUseCase() throws {
    let useCase: DummySearchInteractorType = TestInjection().resolve()
    let stream = useCase.execute(request: "a")
    let result = try? stream.toBlocking().last()

    XCTAssert(result?.count ?? 0 > 0, "Should be found movie with title that include a")

    let query = "aw234wer"
    let streamZero = useCase.execute(request: query)
    let resultZero = try? streamZero.toBlocking().last()

    XCTAssert(resultZero?.count ?? 0 == 0, "Should be not found movie with title that include \(query)")
  }
}
