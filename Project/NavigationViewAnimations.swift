//
//  NavigationViewAnimations.swift
//  Project
//
//  Created by Adam Derradji on 16/10/2019.
//  Copyright © 2019 nala. All rights reserved.
//

import UIKit

extension NavigationView {
  
  func animateIconColour(offset: CGFloat) {
    
  }
  
  func animateIconPosition(offset: CGFloat) {
    let finalDistanceFromBottom: CGFloat = 25.0
    var distance = candleButtonBottomConstraintConstant - finalDistanceFromBottom
    
    candleButtonBottomConstraint.constant = candleButtonBottomConstraintConstant - (distance * offset)
    
    distance = statsIconBottomConstraintConstant - finalDistanceFromBottom
    
    statsIconBottomConstraint.constant = statsIconBottomConstraintConstant - (distance * offset)
  }
  
  func animateIconScale(offset: CGFloat) {
    let finalWidthScale = candleButtonWidthConstraintConstant * 0.2
    
    candleButtonWidthConstraint.constant = candleButtonWidthConstraintConstant - (finalWidthScale * offset)
    
    let scale = statsIconWidthConstraintConstant * 0.2
    statsIconWidthConstraint.constant = statsIconWidthConstraintConstant - (scale * offset)
  }
  
  func animateIconCentre(offset: CGFloat) {
    let originalMultiplier = statsIconHorizontalConstraint.multiplier * bounds.width * 0.5
    let newMultiplier = (bounds.width * 0.54 * 0.5) - originalMultiplier
    
    statsIconHorizontalConstraint.constant = newMultiplier * offset
    resourcesIconHorizontalConstraint.constant = -newMultiplier * offset
  }
  
  func animateBottomBar(percent: CGFloat) {
    let offset = abs(percent)
    let scaleTransform = CGAffineTransform(scaleX: offset, y: 1)
    let distance = bounds.width * 0.23
    
    let transform = indicatorTransform.translatedBy(x: distance * percent,
                                                    y: 0)
    indicator.transform = transform.concatenating(scaleTransform)
    indicator.alpha = offset
  }
  
}
