//
//  MainViewController.swift
//  Project
//
//  Created by Adam Derradji on 15/10/2019.
//  Copyright © 2019 nala. All rights reserved.
//

import UIKit

protocol ColourView {
  var controllerColour: UIColor { get set }
}

class MainViewController: UIViewController {

  var scrollViewController: ScrollViewController!
  var timerViewController: TimerViewController!
  
  lazy var statsViewController: UIViewController! = {
    return self.storyboard?.instantiateViewController(withIdentifier: "StatsViewController")
  }()
  
  lazy var candlesViewController: UIViewController! = {
    return self.storyboard?.instantiateViewController(withIdentifier: "CandlesViewController")
  }()
  
  lazy var resourcesViewController: UIViewController! = {
    return self.storyboard?.instantiateViewController(withIdentifier: "ResourcesViewController")
  }()
  
  @IBOutlet var navigationView: UIView!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? TimerViewController {
      timerViewController = controller
    } else if let controller = segue.destination as? ScrollViewController {
      scrollViewController = controller
      scrollViewController.delegate = self
    }
  }

}

extension MainViewController {
  
  @IBAction func handleCandleButton(_ sender: UITapGestureRecognizer) {
    scrollViewController.setController(to: candlesViewController, animated: true)
  }
  
  @IBAction func handleStatsIconTap(_ sender: UITapGestureRecognizer) {
    scrollViewController.setController(to: statsViewController, animated: true)
  }
  
  @IBAction func handleResourcesIconTap(_ sender: UITapGestureRecognizer) {
    scrollViewController.setController(to: resourcesViewController, animated: true)
  }
  
}

extension MainViewController: ScrollViewControllerDelegate {
  
  var viewControllers: [UIViewController?] {
    return [statsViewController, candlesViewController, resourcesViewController]
  }
  
  var initialViewController: UIViewController {
    return candlesViewController
  }
  
  func scrollViewDidScroll() {
    
    let min: CGFloat = 0
    let max: CGFloat = scrollViewController.pageSize.width
    let x = scrollViewController.scrollView.contentOffset.x
    let result = ((x - min) / (max - min)) - 1
    
    var controller: UIViewController?
    
    if scrollViewController.isControllerVisible(statsViewController) {
      controller = statsViewController
    } else if scrollViewController.isControllerVisible(resourcesViewController) {
      controller = resourcesViewController
    }
    
    // navigationView.animate(to: controller, percent: result)
  }
  
}
