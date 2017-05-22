//
//  Tweet.swift
//  Twidder
//
//  Created by Javi Lorbada on 22/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import Unbox

struct Tweet {
  
  let id: String
  let text: String
  let url: String
  let user: User
  let location: Geolocation?
}

extension Tweet: Unboxable {
  
  init(unboxer: Unboxer) throws {
    self.id = try unboxer.unbox(key: "id")
    self.text = try unboxer.unbox(key: "text")
    self.user = try unboxer.unbox(key: "user")
    self.url = "https://twitter.com/\(self.user.screenName)/status/\(self.id)"
    self.location = unboxer.unbox(key: "geo")
  }
}
