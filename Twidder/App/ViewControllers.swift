//
//  ViewControllers.swift
//  Twidder
//
//  Created by Javi Lorbada on 21/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

enum ViewControllers {
  
  case map(appCoordinator: ApplicationCoordinator)
  case browser(url: URL)
}

// MARK: - ViewControllers View
extension ViewControllers {
  
  func view() -> UIViewController {
    switch self {
    case .map(let appCoordinator):
      return MapViewController(viewModel: MapViewModel(coordinator: appCoordinator))
    case .browser(let url):
      return SFSafariViewController(url: url)
    }
  }
}

// MARK: - ViewControllers Navigation Title
extension ViewControllers {
  
  func title() -> String? {
    switch self {
    case .map:
      return "Twidder"
    default:
      return nil
    }
  }
}
