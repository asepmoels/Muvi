//
//  MovieRouter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import UIKit

struct MovieRouter {
  func routeToDetail(from viewController: UIViewController, movie: Movie) {
    let router: DetailMovieRouter = Injection.shared.resolve()
    router.routeToDetailMovie(from: viewController, movie: movie)
  }
}
