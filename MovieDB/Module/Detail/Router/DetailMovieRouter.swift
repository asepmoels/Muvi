//
//  DetailMovieRouter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import UIKit
import Movies
import Core

struct DetailMovieRouter {
  func routeToDetailMovie(from viewController: UIViewController, movie: Movie) {
    let detail: DetailMovieViewController = Injection.shared.resolve()
    detail.movieID = movie.identifier
    viewController.navigationController?.pushViewController(detail, animated: true)
  }

  func routeToYoutubePlayer(from viewController: UIViewController, videoId: String) {
    let player: YoutubePlayerViewController = Injection.shared.resolve(argument: videoId)
    viewController.present(player, animated: true, completion: nil)
  }
}
