//
//  HMButton.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/16/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class HMButton: UIButton {
    let cardHighlightedFactor: CGFloat = 0.95
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
}

extension HMButton {
    func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        
        if isHighlighted && !isSelected {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions,
                           animations: {
                            self.transform = .init(scaleX: self.cardHighlightedFactor,
                                                   y: self.cardHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions,
                           animations: {
                            self.transform = .identity
            }, completion: completion)
        }
        

    }
    
    open func setBackgroundAlpha(_ alpha: CGFloat) {
        self.backgroundColor = self.backgroundColor?.withAlphaComponent(alpha)
    }
}
