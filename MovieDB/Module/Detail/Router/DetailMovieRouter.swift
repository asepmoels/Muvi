//
//  DetailMovieRouter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import UIKit

struct DetailMovieRouter {
  func routeToDetailMovie(from viewController: UIViewController, movie: Movie) {
    let presenter: DetailMoviePresenter = Injection.shared.resolve()
    presenter.movieId = "\(movie.identifier)"
    let detail = DetailMovieViewController(presenter: presenter)
    viewController.navigationController?.pushViewController(detail, animated: true)
  }
}
