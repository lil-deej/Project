//
//  CandlesViewController.swift
//  Project
//
//  Created by Adam Derradji on 15/10/2019.
//  Copyright © 2019 nala. All rights reserved.
//

import UIKit

enum ScrollDirection {
  case scrollRight, scrollLeft, noScroll
}

class CandlesViewController: UIViewController {

  @IBOutlet weak var candleView: UIView!
  @IBOutlet weak var candleCollectionView: UICollectionView!
  
  private let candleColours: [UIColor] = [
    #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
  ]
  var lastContentOffset: CGFloat = 0
  var scrollDirection: ScrollDirection = .noScroll
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    candleCollectionView.delegate = self
    candleCollectionView.dataSource = self
    candleCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    candleCollectionView.register(CandleRectangleCell.self, forCellWithReuseIdentifier: CandleRectangleCell.identifier)
    candleCollectionView.showsHorizontalScrollIndicator = false
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let middleIndexPath = IndexPath(item: candleColours.count / 2, section: 0)
    selectCell(for: middleIndexPath, animated: false)
  }
  
  private func selectCell(for indexPath: IndexPath, animated: Bool) {
    candleCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    candleView.backgroundColor = candleColours[indexPath.row]
  }
  
  private func newIndexPath(for scrollDirection: ScrollDirection, with point: CGPoint) -> IndexPath? {
    let yPosition = candleCollectionView.bounds.size.height / 2
    
    switch scrollDirection {
    case .scrollLeft:
      let newXPosition = point.x - 20
      return candleCollectionView.indexPathForItem(at: CGPoint(x: newXPosition, y: yPosition))
    case .scrollRight:
      let newXPosition = point.x + 20
      return candleCollectionView.indexPathForItem(at: CGPoint(x: newXPosition, y: yPosition))
    case .noScroll:
      return nil
    }
  }
  
}

extension CandlesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return candleColours.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectCell(for: indexPath, animated: true)
  }
}

extension CandlesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CandleRectangleCell.identifier, for: indexPath) as? CandleRectangleCell else { fatalError() }
    
    cell.colour = candleColours[indexPath.row]
    return cell
  }
}

extension CandlesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = candleCollectionView.frame.height * 0.9
    let width = height * 2 / 3
    return CGSize(width: width, height: height)
  }
}

extension CandlesViewController: UIScrollViewDelegate {

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let bounds = candleCollectionView.bounds

    let xPosition = bounds.origin.x + bounds.size.width / 2
    let yPosition = bounds.size.height / 2

    let xyPoint = CGPoint(x: xPosition, y: yPosition)

    guard let indexPath = candleCollectionView.indexPathForItem(at: xyPoint) else {
      
      if let offsetIndexPath = newIndexPath(for: scrollDirection, with: xyPoint) {
        selectCell(for: offsetIndexPath, animated: true)
      } else { return }
      
      return
    }

    selectCell(for: indexPath, animated: true)
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      scrollViewDidEndDecelerating(scrollView)
    }
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    scrollViewDidEndDecelerating(scrollView)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if lastContentOffset < scrollView.contentOffset.x {
      scrollDirection = .scrollRight
    } else if lastContentOffset > scrollView.contentOffset.x {
      scrollDirection = .scrollLeft
    }
    
    lastContentOffset = scrollView.contentOffset.x
  }

}
