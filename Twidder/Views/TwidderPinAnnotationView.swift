//
//  TwidderPinAnnotationView.swift
//  Twidder
//
//  Created by Javi Lorbada on 22/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import UIKit
import MapKit

class TwidderPinAnnotationView: MKPinAnnotationView {

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    isEnabled = true
    canShowCallout = true
    
    let infoButton = UIButton(type: .detailDisclosure)
    rightCalloutAccessoryView = infoButton
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
