//
//  SwipeableContainerView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/7/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit
import Gemini

class SwipeableViewCell: GeminiCell {
    
    var cardView : ContainerStackView = ContainerStackView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    func setLayout(){
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalTo: heightAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func setCardView(_ card: ContainerStackView) {
        self.cardView = card
        self.contentView.addSubview(self.cardView)
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            cardView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            cardView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
