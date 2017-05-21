//
//  AppCoordinator.swift
//  Twidder
//
//  Created by Javi Lorbada on 21/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
  
  func start()
}

struct ApplicationCoordinator: Coordinator {
  
  private let window: UIWindow
  private let rootViewController: UINavigationController
  
  init(window: UIWindow) {
    self.window = window
    self.rootViewController = UINavigationController()
  }
  
  // MARK: - Public
  func start() {
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
  
  @discardableResult
  func open(viewController: ViewControllers, animated: Bool) -> Bool {
    
    prepareAndPush(viewController: viewController, animated: animated)
    return true
  }
  
  // MARK: - Private
  private func prepareAndPush(viewController: ViewControllers, animated: Bool) {
    let view = viewController.view()
    view.title = viewController.title()
    rootViewController.pushViewController(view, animated: animated)
  }
}
