//
//  ReactiveLocation.swift
//  Twidder
//
//  Created by Javi Lorbada on 22/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import CoreLocation
import ReactiveSwift
import Result

enum LocationError: Error {
  case locationError(CLError.Code)
}

enum LocationAuthorizationError: LocalizedError {
  case authorizationDenied
  case authorizationRestricted
  
  var errorDescription: String {
    switch self {
    case .authorizationDenied:
      return "Authorization denied, please access you settings and enable location in order to search tweets around you."
    case .authorizationRestricted:
      return "Authorization restricted, please access you settings and enable location in order to search tweets around you."
    }
  }
}

final class LocationService: NSObject {

  let locationSignal: Signal<CLLocation, LocationError>
  let permissionSignal: Signal<CLAuthorizationStatus, LocationAuthorizationError>
  
  private let locationObserver: Signal<CLLocation, LocationError>.Observer
  private let permissionObserver: Signal<CLAuthorizationStatus, LocationAuthorizationError>.Observer
  
  private let locationManager: CLLocationManager
  
  override init() {
    locationManager = CLLocationManager()
  
    (locationSignal, locationObserver) = Signal<CLLocation, LocationError>.pipe()
    (permissionSignal, permissionObserver) = Signal<CLAuthorizationStatus, LocationAuthorizationError>.pipe()
    
    super.init()
    
    setupBindings()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    
    if CLLocationManager.authorizationStatus() == .notDetermined {
      requestAuthorization()
    } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      start()
    }
  }
  
  deinit {
    locationObserver.sendCompleted()
    permissionObserver.sendCompleted()
  }
  
  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func start() {
    locationManager.startUpdatingLocation()
  }
  
  func stop() {
    locationManager.stopUpdatingLocation()
  }
  
  private func setupBindings() {
    reactive.signal(for: #selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
      .map { locationObject -> CLAuthorizationStatus? in
        let nonNilLocationObject = locationObject.flatMap { $0 }
        guard let authorizedStatus = nonNilLocationObject.last as? Int32 else {
          return nil
        }
        return CLAuthorizationStatus(rawValue: authorizedStatus)
      }
      .skipNil()
      .observeValues { [weak self] locationStatus in
        switch locationStatus {
        case .authorizedWhenInUse:
          self?.permissionObserver.send(value: .authorizedWhenInUse)
        case .authorizedAlways:
          self?.permissionObserver.send(value: .authorizedAlways)
        case .denied:
          self?.permissionObserver.send(error: .authorizationDenied)
        case .restricted:
          self?.permissionObserver.send(error: .authorizationRestricted)
        case .notDetermined:
          dump("Not determined")
        }
      }
    
    reactive.signal(for: #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
      .map { locationObject -> CLLocation? in
        let nonNilLocationObject = locationObject.flatMap { $0 }
        guard let locations = nonNilLocationObject.last as? [CLLocation] else {
          return nil
        }
        return locations.last
      }
      .skipNil()
      .observeValues { [weak self] location in
        self?.locationObserver.send(value: location)
      }
  }
}

extension LocationService: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
}
