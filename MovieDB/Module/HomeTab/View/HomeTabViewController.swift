//
//  HomeTabViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit

class HomeTabViewController: UITabBarController {
  private let router: HomeRouter

  init(router: HomeRouter) {
    self.router = router
    super.init(nibName: nil, bundle: nil)
    configureTabs()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func configureTabs() {
    let subViewControllers = [
      router.makeMoviesView(),
      router.makeSearchView(),
      router.makeAboutView()
    ]

    viewControllers = subViewControllers

    tabBar.backgroundColor = .mainBarColor
    tabBar.backgroundImage = UIImage()
    tabBar.tintColor = .primaryYellow
    tabBar.unselectedItemTintColor = .white
  }
}
