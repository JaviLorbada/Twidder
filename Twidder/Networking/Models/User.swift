//
//  User.swift
//  Twidder
//
//  Created by Javi Lorbada on 22/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import Foundation
import Unbox

struct User {
  
  let id: String
  let name: String
  let screenName: String
}

extension User: Unboxable {
  
  init(unboxer: Unboxer) throws {
    self.id = try unboxer.unbox(key: "id")
    self.name = try unboxer.unbox(key: "name")
    self.screenName = try unboxer.unbox(key: "screen_name")
  }
}
