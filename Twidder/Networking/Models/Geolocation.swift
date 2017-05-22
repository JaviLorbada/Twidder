//
//  Geolocation.swift
//  Twidder
//
//  Created by Javi Lorbada on 22/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import Unbox

struct Geolocation {
  
  let latitude: Double
  let longitude: Double
}

extension Geolocation: Unboxable {
  
  init(unboxer: Unboxer) throws {
    self.latitude = try unboxer.unbox(keyPath: "coordinates.0")
    self.longitude = try unboxer.unbox(keyPath: "coordinates.1")
  }
}
