//
//  MapViewController.swift
//  Twidder
//
//  Created by Javi Lorbada on 21/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import UIKit
import MapKit

struct MapViewModel { }

final class MapViewController: UIViewController {

  fileprivate let viewModel: MapViewModel
  fileprivate let searchBar: UISearchBar
  fileprivate let mapView: MKMapView
  fileprivate lazy var views: [UIView] = {
    return [self.mapView, self.searchBar]
  }()
  
  // MARK: - Lifecycle
  init(viewModel: MapViewModel) {
    self.viewModel = viewModel
    self.searchBar = UISearchBar()
    self.mapView = MKMapView()
    
    super.init(nibName: nil, bundle: nil)
    
    setupConstraints()
  }
  
  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    fatalError("this is a xibless class utilizing for autolayout, use init() instead")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Private
  private func setupConstraints() {
    for v in views {
      view.addSubview(v)
      v.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
}
