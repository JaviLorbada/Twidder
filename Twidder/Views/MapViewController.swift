//
//  MapViewController.swift
//  Twidder
//
//  Created by Javi Lorbada on 21/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import UIKit
import MapKit
import ReactiveCocoa
import ReactiveSwift

final class MapViewController: UIViewController {

  fileprivate let viewModel: MapViewModel
  fileprivate let searchBar: UISearchBar
  fileprivate let mapView: MKMapView
  fileprivate let locationButton: LocationButton
  fileprivate lazy var views: [UIView] = {
    return [self.mapView, self.searchBar, self.locationButton]
  }()
  
  // MARK: - Lifecycle
  init(viewModel: MapViewModel) {
    self.viewModel = viewModel
    self.searchBar = UISearchBar()
    self.mapView = MKMapView()
    self.locationButton = LocationButton()
    
    super.init(nibName: nil, bundle: nil)
    
    setupViews()
    setupConstraints()
    setupBindings()
  }
  
  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    fatalError("this is a xibless class utilizing for autolayout, use init() instead")
  }
  
  // MARK: - Private
  private func setupViews() {
    for v in views {
      view.addSubview(v)
      v.translatesAutoresizingMaskIntoConstraints = false
    }
    searchBar.delegate = self
    mapView.delegate = self
  }
  
  private func setupConstraints() {
    
    NSLayoutConstraint.activate([
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
      locationButton.widthAnchor.constraint(equalToConstant: 50),
      locationButton.heightAnchor.constraint(equalTo: locationButton.widthAnchor)
    ])
  }
  
}
