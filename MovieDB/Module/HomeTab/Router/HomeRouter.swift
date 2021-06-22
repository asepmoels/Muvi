//
//  HomeRouter.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Common

struct HomeRouter {
  func routeToHome(from window: UIWindow) {
    let homeTab: HomeTabViewController = Injection.shared.resolve()
    window.rootViewController = homeTab
  }

  func makeMoviesView() -> UIViewController {
    let moviesView: MoviesViewController = Injection.shared.resolve()
    moviesView.tabBarItem.image = .tabHome
    moviesView.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
    return UINavigationController(rootViewController: moviesView)
  }

  func makeSearchView() -> UIViewController {
    let searchView: SearchViewController = Injection.shared.resolve()
    searchView.tabBarItem.image = .tabSearch
    searchView.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
    return UINavigationController(rootViewController: searchView)
  }

  func makeFavoriteView() -> UIViewController {
    let searchView: FavoriteViewController = Injection.shared.resolve()
    searchView.tabBarItem.image = .tabFavorite
    searchView.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
    return UINavigationController(rootViewController: searchView)
  }

  func makeAboutView() -> UIViewController {
    let aboutView: AboutViewController = Injection.shared.resolve()
    aboutView.tabBarItem.image = .tabAbout
    aboutView.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
    return UINavigationController(rootViewController: aboutView)
  }
}
