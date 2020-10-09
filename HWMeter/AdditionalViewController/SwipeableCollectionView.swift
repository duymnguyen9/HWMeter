//
//  SwipeableCollectionView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/8/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit


//class SwipeableCollectionView : UICollectionView {
//    
//}
//
//extension SwipeableCollectionView : UICollectionViewDelegate {
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let cellHeight = 
//        let numberOfCells = 2
//        let page = Int(scrollView.contentOffset.y) / Int()
//        if page == 0 { // we are within the fake last, so delegate real last
//            currentPage = numberOfCells - 1
//        } else if page == numberOfCells - 1 { // we are within the fake first, so delegate the real first
//            currentPage = 0
//        } else { // real page is always fake minus one
//           currentPage = page - 1
//        }
//        // if you need to know changed position, you can delegate it
//        customDelegate?.pageChanged(currentPage)
//    }
//
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let numberOfCells = 2
//
//        let regularContentOffset = cellWidth * CGFloat(numberOfCells - 2)
//        if (scrollView.contentOffset.x >= cellWidth * CGFloat(numberOfCells - 1)) {
//            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - regularContentOffset, y: 0.0)
//        } else if (scrollView.contentOffset.x < cellWidth) {
//            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + regularContentOffset, y: 0.0)
//        }
//    }
//}
