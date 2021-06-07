//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let homeRouter: HomeRouter = Injection.shared.resolve()
    homeRouter.routeToHome(from: window)
    self.window = window
    self.window?.makeKeyAndVisible()
    return true
  }
}
