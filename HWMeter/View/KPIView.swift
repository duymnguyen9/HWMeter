//
//  KPIView.swift
//  HWTest
//
//  Created by Duy Nguyen on 8/20/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class KPIView: UIView {
    var kpiViewModel: SensorInfo = SensorInfo(title: " ",
                                              value: " ",
                                              unit: " ") {
        didSet {
            switch kpiViewModel.title {
            case "CORE CLOCK":
                accentBar.backgroundColor = UIColor(cgColor: Theme.gradientColors2[0])
            case "POWER":
                accentBar.backgroundColor = UIColor(cgColor: Theme.gradientColors2[1])
            case "VRM TEMP":
                accentBar.backgroundColor = UIColor(cgColor: Theme.gradientColors1[0])
            case "VRM USAGE":
                accentBar.backgroundColor = UIColor(cgColor: Theme.gradientColors1[1])
            default:
                accentBar.backgroundColor = Theme.secondaryBirches
            }
            titleLabel.text = kpiViewModel.title
            valueLabel.text = kpiViewModel.value
            unitLabel.text = kpiViewModel.unit
        }
    }
    
    let titleLabel: UILabel = UILabel()
    let valueLabel: UILabel = UILabel()
    let unitLabel: UILabel = UILabel()
    let value: CGFloat = 15
    
    let accentBar : UIView = UIView(frame: .zero)
    let containerView = UIView(frame: .zero)
    
    var landscapeContainerConstraint : NSLayoutConstraint?
    var landscapeAccentBarConstraint : NSLayoutConstraint?
    var portraitContainerConstraint : NSLayoutConstraint?
    var portraitAccentBarConstraint : NSLayoutConstraint?
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        accentBar.backgroundColor = Theme.frontColor
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)

        accentBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accentBar)
        
        landscapeContainerConstraint = containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85)
        landscapeAccentBarConstraint = accentBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.075)
        portraitContainerConstraint = containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95)
        portraitAccentBarConstraint = accentBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.025)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(unitLabel)
        
        if GlobalConstants.isDebug {
            layer.borderColor = UIColor.orange.cgColor
            layer.borderWidth = 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpLabel()
    }
    
    func setUpLabel() {
        
        titleLabel.text = kpiViewModel.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.25)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.87)
        
        valueLabel.text = kpiViewModel.value
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * 0.3)
        valueLabel.textColor = UIColor.white
        
        unitLabel.text = kpiViewModel.unit
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * 0.3)
        unitLabel.textColor = Theme.frontColor
        

        
        if UIDevice.current.orientation.isLandscape {
            portraitContainerConstraint?.isActive = false
            portraitAccentBarConstraint?.isActive = false
            landscapeContainerConstraint?.isActive = true
            landscapeAccentBarConstraint?.isActive = true
         } else {
                
            landscapeContainerConstraint?.isActive = false
             landscapeAccentBarConstraint?.isActive = false
             portraitContainerConstraint?.isActive = true
             portraitAccentBarConstraint?.isActive = true
         }
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            valueLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            unitLabel.leftAnchor.constraint(equalTo: valueLabel.rightAnchor),
            unitLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor),
            
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
//            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
//            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            accentBar.leftAnchor.constraint(equalTo: leftAnchor),
//            accentBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.025),
//            accentBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.075),
            accentBar.topAnchor.constraint(equalTo: topAnchor),
            accentBar.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor),
        ])
    }
}
