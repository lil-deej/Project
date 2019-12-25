//
//  CandlesFlowLayout.swift
//  Project
//
//  Created by Adam Derradji on 24/10/2019.
//  Copyright © 2019 nala. All rights reserved.
//

import UIKit

let defaultItemScale: CGFloat = 0.6

class CandlesFlowLayout: UICollectionViewFlowLayout {
  
  var isSetup = false
  
  override func prepare() {
    super.prepare()
    
    if !isSetup {
      setupCollectionView()
      isSetup = true
    }
    
    scrollDirection = .horizontal
    minimumLineSpacing = 0
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    var attributesCopy: [UICollectionViewLayoutAttributes] = []
    
    for itemAttributes in attributes! {
      let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
      changeLayoutAttributes(itemAttributesCopy)
      attributesCopy.append(itemAttributesCopy)
    }
    return attributesCopy
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  private func changeLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) {
    
    let collectionCentre = collectionView!.frame.size.width / 2
    let offset = collectionView!.contentOffset.x
    let normalizedCentre = attributes.center.x - offset
    
    let maxDistance = itemSize.width + minimumLineSpacing
    let actualDistance = abs(collectionCentre - normalizedCentre)
    let scaleDistance = min(actualDistance, maxDistance)
    
    let ratio = (maxDistance - scaleDistance) / maxDistance
    let scale = defaultItemScale + ratio * (1 - defaultItemScale)
    
    attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
  }
  
  func setupCollectionView() {
    guard let collectionView = collectionView else { return }
    let collectionSize = collectionView.bounds.size
    let xInset = (collectionSize.width - itemSize.width) / 2
    sectionInset = UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset)
  }
  
  func closestIndexpath(forOffset offset: CGPoint) -> IndexPath {
    guard let cv = collectionView else { return IndexPath(item: 0, section: 0) }
    
    let items = layoutAttributesForElements(in: CGRect(origin: offset, size: cv.frame.size)) ?? []
    let distancesToCentre = items.map {
      abs($0.frame.midX.distance(to: cv.frame.width * 0.5 + offset.x))
    }
    
    let minimum = zip(items, distancesToCentre).min { first, second in
      first.1 < second.1
    }
    guard let targetAttribute = minimum else { return IndexPath(item: 0, section: 0) }
    return targetAttribute.0.indexPath
  }
  
  func middleOffset(forIndexPath indexPath: IndexPath) -> CGPoint {
    guard let attribute = layoutAttributesForItem(at: indexPath), let cv = collectionView else { return .zero }
    let x = attribute.frame.minX + (attribute.frame.width - cv.frame.width) * 0.5
    return CGPoint(x: x, y: 0)
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    let middleIndexPath = closestIndexpath(forOffset: proposedContentOffset)
    return middleOffset(forIndexPath: middleIndexPath)
  }
}
