//
//  AppDelegate.swift
//  Twidder
//
//  Created by Javi Lorbada on 21/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private lazy var applicationCoordinator: ApplicationCoordinator = {
    guard let wd = self.window else {
      fatalError("No window available, please check application didFinishLaunchingWithOptions")
    }
    return ApplicationCoordinator(window: wd)
  }()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    guard let wd = window else {
      return false
    }
    applicationCoordinator = ApplicationCoordinator(window: wd)
    applicationCoordinator.start()
    return applicationCoordinator.open(viewController: .map(appCoordinator: applicationCoordinator), animated: true)
  }
  
  func applicationWillTerminate(_ application: UIApplication) {

  }
}
