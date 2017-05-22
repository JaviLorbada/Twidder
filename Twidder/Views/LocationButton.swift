//
//  LoginButton.swift
//  Twidder
//
//  Created by Javi Lorbada on 21/05/2017.
//  Copyright © 2017 Javi Lorbada. All rights reserved.
//

import UIKit

class LocationButton: UIButton {

  private let normalColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
  private let highlightedColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 0.5)
  
  override var isHighlighted: Bool {
    didSet { tintColor = isHighlighted ? highlightedColor : normalColor }
  }
  // MARK: - Lifecycle methods
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    styleViews()
  }
  
  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    fatalError("this is a xibless class utilizing for autolayout, use init() instead")
  }
  
  func styleViews() {
    let image = #imageLiteral(resourceName: "noun_152583_cc").withRenderingMode(.alwaysTemplate)
    setImage(image, for: .normal)
    tintColor = normalColor
  }

}
