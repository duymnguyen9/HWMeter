//
//  SnappingCollectionViewLayout.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/7/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        guard velocity.y != 0 else {
            return CGPoint(x: proposedContentOffset.x, y: 0)
        }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude

        let verticalOffset = proposedContentOffset.y + collectionView.contentInset.top

        let targetRect = CGRect(x: 0,
                                y: proposedContentOffset.y,
                                width: collectionView.bounds.size.width,
                                height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.y
            if fabsf(Float(itemOffset - verticalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - verticalOffset
            }
        })
        
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y  + offsetAdjustment)
    }
    
}
