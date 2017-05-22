//
//  Statuses.swift
//  Twidder
//
//  Created by Javi Lorbada on 22/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import Unbox

struct Statuses {

  let tweets: [Tweet]
}

extension Statuses: Unboxable {
  
  init(unboxer: Unboxer) throws {
    self.tweets = try unboxer.unbox(key: "statuses")
  }
}
