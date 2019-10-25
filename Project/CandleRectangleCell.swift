//
//  CandleRectangleCell.swift
//  Project
//
//  Created by Adam Derradji on 24/10/2019.
//  Copyright © 2019 nala. All rights reserved.
//

import UIKit

class CandleRectangleCell: UICollectionViewCell {
    
  static let identifier = "CandleCell"
  
  var colour: UIColor? {
    didSet {
      guard let colour = colour else { return }
      contentView.backgroundColor = colour
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.cornerRadius = 16
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
