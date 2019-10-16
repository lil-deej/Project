//
//  NavigationView.swift
//  Project
//
//  Created by Adam Derradji on 15/10/2019.
//  Copyright © 2019 nala. All rights reserved.
//

import UIKit

class NavigationView: UIView {

  lazy var candleButtonWidthConstraintConstant: CGFloat = {
    return self.candleButtonWidthConstraint.constant
  }()
  
  lazy var candleButtonBottomConstraintConstant: CGFloat = {
    return self.candleButtonBottomConstraint.constant
  }()
  
  lazy var statsIconWidthConstraintConstant: CGFloat = {
    return self.statsIconWidthConstraint.constant
  }()
  
  lazy var statsIconBottomConstraintConstant: CGFloat = {
    return self.statsIconBottomConstraint.constant
  }()
  
  lazy var statsIconHorizontalConstraintConstant: CGFloat = {
    return self.statsIconHorizontalConstraint.constant
  }()
  
  lazy var resourcesIconHorizontalConstraintConstant: CGFloat = {
    return self.resourcesIconHorizontalConstraint.constant
  }()
  
  lazy var indicatorTransform: CGAffineTransform = {
    return self.candleButtonView.transform
  }()
  
  @IBOutlet var candleButtonView: UIView!
  @IBOutlet var candleButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet var candleButtonBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet var statsIconView: UIView!
  @IBOutlet var statsIconWidthConstraint: NSLayoutConstraint!
  @IBOutlet var statsIconBottomConstraint: NSLayoutConstraint!
  @IBOutlet var statsIconHorizontalConstraint: NSLayoutConstraint!
  
  @IBOutlet var resourcesIconView: UIView!
  @IBOutlet var resourcesIconHorizontalConstraint: NSLayoutConstraint!
  
  @IBOutlet var indicator: UIView!
  
  @IBOutlet var colourView: UIView!
  
  func shadow(layer: CALayer, colour: UIColor) {
    layer.shadowColor = colour.cgColor
    layer.masksToBounds = false
    layer.shadowOffset = .zero
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 0.5
  }
  
  func setup() {
    // shadow(layer: candleButtonWhiteView.layer, colour: .black)
    // shadow(layer: statsIconWhiteView.layer, colour: .darkGray)
    // shadow(layer: resourcesIconWhiteView.layer, colour: .darkGray)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    indicator.layer.cornerRadius = indicator.bounds.height / 2
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.hitTest(point, with: event)
    return view == self ? nil : view
  }
  
  func animate(to controller: UIViewController?, percent: CGFloat) {
    let offset = abs(percent)
    
    // candleButtonWhiteView.alpha = 1 - offset
    // candleButtonGreyView.alpha = offset
    
    // animateIconColour(offset: offset)
    animateIconPosition(offset: offset)
    animateIconScale(offset: offset)
    animateIconCentre(offset: offset)
    
    animateBottomBar(percent: percent)
    
    if let controller = controller as? ColourView {
      colourView.backgroundColor = controller.controllerColour
    }
    
    var colourOffset = (offset - 0.2) / (0.8 - 0.2)
    colourOffset = min(max(colourOffset, 0), 1)
    colourView.alpha = offset
    
    layoutIfNeeded()
  }
  
}
