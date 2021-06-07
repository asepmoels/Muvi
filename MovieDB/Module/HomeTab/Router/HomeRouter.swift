//
//  HomeRouter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit

struct HomeRouter {
  func routeToHome(from window: UIWindow) {
    let homeTab: HomeTabViewController = Injection.shared.resolve()
    window.rootViewController = homeTab
  }

  func makeMoviesView() -> UIViewController {
    let moviesView: MoviesViewController = Injection.shared.resolve()
    moviesView.tabBarItem.image = UIImage(named: "tab_home")
    moviesView.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
    return UINavigationController(rootViewController: moviesView)
  }
}
