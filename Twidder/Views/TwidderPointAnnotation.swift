//
//  TwidderPointAnnotation.swift
//  Twidder
//
//  Created by Javi Lorbada on 22/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import UIKit
import MapKit

class TwidderPointAnnotation: MKPointAnnotation {

  let tweet: Tweet

  init?(tweet: Tweet) {
    self.tweet = tweet
    guard let center = tweet.location else {
      return nil
    }
    super.init()
    
    self.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
    self.title = tweet.user.name
  }
}
