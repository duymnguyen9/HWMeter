//
//  SwipeableContainerView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/7/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class SwipeableViewCell: UICollectionViewCell {
    let generalView = UIView()
    let powerView = UIView()
    let collectionView = UICollectionView()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setLayout(){
        
    }
}
