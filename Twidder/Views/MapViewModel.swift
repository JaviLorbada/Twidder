//
//  MapViewController.swift
//  Twidder
//
//  Created by Javi Lorbada on 21/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import OAuthSwift
import ReactiveSwift
import Result
import CoreLocation

struct MapViewModel {
  
  let results: Property<[Tweet]>
  let location: Property<CLLocation>
  let authorizationSuccessful: Property<CLAuthorizationStatus>
  let authorizationFailed: Property<LocationAuthorizationError>
  let locationAction: Action<Void, Void, NoError>
  
  // Do not expose the implementation details
  private let (searchTermSignal, searchTermSink) = Signal<String, NoError>.pipe()
  private let (resultsSignal, resultsSink) = Signal<[Tweet], NoError>.pipe()
  private let (locationSignal, locationSink) = Signal<CLLocation, NoError>.pipe()
  private let (authorizationSuccessfulSignal, authorizationSuccessfulSink) = Signal<CLAuthorizationStatus, NoError>.pipe()
  private let (authorizationFailedSignal, authorizationFailedSink) = Signal<LocationAuthorizationError, NoError>.pipe()
  
  private let appCoordinator: ApplicationCoordinator
  private let locationService: LocationService
  
  private var getLocationDisposable: Disposable?
  
  init(coordinator: ApplicationCoordinator) {
    
    self.appCoordinator = coordinator
    self.results = Property(initial: [], then: resultsSignal)
    self.location = Property(initial: CLLocation(), then: locationSignal)
    self.authorizationSuccessful = Property(initial: CLAuthorizationStatus.notDetermined, then: authorizationSuccessfulSignal)
    self.authorizationFailed = Property(initial: LocationAuthorizationError.authorizationDenied, then: authorizationFailedSignal)
    self.locationAction = Action { _ in
      return SignalProducer(value: ())
    }
    
    self.locationService = LocationService()
    self.locationService.start()
    
    setupBindings()
  }
    
  // MARK: - Private
  func setupBindings() {
    
    locationService.locationSignal.observeResult {
      switch $0 {
      case .success(let location):
        self.locationSink.send(value: location)
        self.locationService.stop()
      case .failure(let error):
        dump(error)
      }
    }
    
    locationAction.values.observeValues { _ in
      self.locationService.start()
    }
    
    locationService.permissionSignal.observeResult {
      switch $0 {
      case .success(let status):
        self.authorizationSuccessfulSink.send(value: status)
        self.locationService.start()
      case .failure(let error):
        self.authorizationFailedSink.send(value: error)
      }
    }
    
    let disposable = SerialDisposable()
    
    searchTermSignal.observeValues { term in
      disposable.inner?.dispose()
      disposable.inner = QueueScheduler(name: "com.twidder.gettweets").schedule(after: Date(), interval: .seconds(10), action: {
        TwitterAPI
          .getTweets(for: term, around: Geolocation(latitude: self.location.value.coordinate.latitude,
                                                    longitude: self.location.value.coordinate.longitude))
          .startWithResult { (result) in
            switch result {
            case .success(let tweets):
              if tweets.isEmpty {
                disposable.inner?.dispose()
              }
              self.resultsSink.send(value: tweets)
            case .failure(let error):
              dump(error)
            }
          }
      })
    }
  }

  // MARK: - Public
  func showAlert(with data: AlertData) {
    appCoordinator.showAlert(with: data)
  }
  
  func open(url: URL) {
    appCoordinator.open(viewController: .browser(url: url), animated: true)
  }
  
  public func setSearchTerm(_ term: String) {
    searchTermSink.send(value: term)
  }
}
