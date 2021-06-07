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
      MoviesViewController()
    }
  }

  func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
