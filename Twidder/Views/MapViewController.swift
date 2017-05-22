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
  
  private func setupBindings() {
  
    reactive.trigger(for: #selector(UISearchBarDelegate.searchBarSearchButtonClicked(_:)))
    .observe(on: QueueScheduler.main)
    .map { _ in self.searchBar.text }
    .skipNil()
    .observeValues { [weak self] term in
      self?.viewModel.setSearchTerm(term)
    }
    
    searchBar.reactive.isUserInteractionEnabled <~ Signal.merge([viewModel.authorizationFailed.signal.map { _ in return false },
                                                                 viewModel.authorizationSuccessful.signal.map { _ in return true }])
    
    viewModel.authorizationFailed.signal
      .observe(on: QueueScheduler.main)
      .observeValues { [weak self] error in
        self?.viewModel.showAlert(with: AlertData(title: "Error", message: error.errorDescription))
      }
    
    viewModel.results.signal.map { tweets -> [MKAnnotation] in
      return tweets.map { TwidderPointAnnotation(tweet: $0) }.flatMap { $0 }
    }
    .observe(on: QueueScheduler.main)
    .observeValues { [weak self] newAnnotations in
      if newAnnotations.isEmpty {
        self?.viewModel.showAlert(with: AlertData(title: "Info", message: "No results, please try searching another word"))
      }
      self?.showAnnotations(newAnnotations)
    }
    
    viewModel.location.signal
    .observe(on: QueueScheduler.main)
    .observeValues { [weak self] location in
      self?.centerMap(in: location)
    }
    
    locationButton.reactive.pressed = CocoaAction(viewModel.locationAction)
    
    reactive.signal(for: #selector(mapView(_:annotationView:calloutAccessoryControlTapped:)))
      .observe(on: QueueScheduler.main)
      .map { tuple -> MKAnnotationView? in
        let annotationView = tuple[1] as? MKAnnotationView
        return annotationView.flatMap { $0 }
      }.skipNil()
      .observeValues { [weak self] annotationView in
        guard let annotationPin = annotationView.annotation as? TwidderPointAnnotation,
              let url = URL(string: annotationPin.tweet.url) else {
          return
        }
        self?.viewModel.open(url: url)
      }
  }
  
  private func centerMap(in location: CLLocation) {
    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
    self.mapView.showsUserLocation = true
    self.mapView.setRegion(region, animated: true)
  }
  
  private func showAnnotations(_ annotations: [MKAnnotation]) {
    let oldAnnotations = mapView.annotations.filter { $0 !== self.mapView.userLocation }
    mapView.removeAnnotations(oldAnnotations)
    mapView.addAnnotations(annotations)
    mapView.showAnnotations(annotations, animated: true)
  }
}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let pointAnnotation = annotation as? TwidderPointAnnotation else {
      return nil
    }
    return TwidderPinAnnotationView(annotation:pointAnnotation, reuseIdentifier:pointAnnotation.tweet.id)
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) { }
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { }
}

extension MapViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}
