//
//  StackBarView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/6/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

struct StackBarViewModel {
    var cpuPower: CGFloat = 0
    var gpuPower: CGFloat = 0
    var miscPower: CGFloat = 0
    var totalPower : CGFloat =  0
    
    init(data: PowerInfo, psuRating: CGFloat) {
        let adjustedPSU = psuRating * 0.9
        self.cpuPower = data.cpuPower / adjustedPSU
        self.gpuPower = data.gpuPower / adjustedPSU
        self.miscPower = data.miscPower / adjustedPSU
        self.totalPower = data.totalPower
    }
    
    init() {}
}

class StackBarView: UIView {
    let psuPower :CGFloat = 650
    
    var viewModel: StackBarViewModel = StackBarViewModel() {
        didSet {
            if viewModel.cpuPower == 0 && viewModel.gpuPower == 0 && viewModel.totalPower == 0 {
                print("initial Load")
                
            } else {
                valueLabel.text = String(Int(viewModel.totalPower))
            }
        }
        willSet {
            self.cpuSegmentWidth.constant = self.bounds.width * newValue.cpuPower
            self.gpuSegmentWidth.constant = self.bounds.width * newValue.gpuPower
            self.miscSegmentWidth.constant = self.bounds.width * newValue.miscPower
            UIView.animate(withDuration: 1,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            self.segmentStackView.setNeedsLayout()
                            self.segmentStackView.layoutIfNeeded()
                           },
                           completion: nil)
        
        }
    }
    
    let valueLabel = UILabel()
    let title = UILabel()
    let unitLabel = UILabel()
    
    var constraintsList: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    let cpuSegment: StackBarSegment = StackBarSegment(frame: .zero)
    let gpuSegment: StackBarSegment = StackBarSegment(frame: .zero)
    let miscSegment: StackBarSegment = StackBarSegment(frame: .zero)
    let freeSegment: StackBarSegment = StackBarSegment(frame: .zero)
    
    var cpuSegmentWidth: NSLayoutConstraint = NSLayoutConstraint()
    var gpuSegmentWidth: NSLayoutConstraint = NSLayoutConstraint()
    var miscSegmentWidth: NSLayoutConstraint = NSLayoutConstraint()
    var freeSegmentWidth: NSLayoutConstraint = NSLayoutConstraint()
    
    var segmentStackView: UIStackView = UIStackView()
    
    var currentOrientation : UIDeviceOrientation = UIDevice.current.orientation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        valueLabel.text = " "
        
        // TESTING
        valueLabel.text = "600"
        title.text = "Power"
        unitLabel.text = "W"
        
        segmentStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentStackView.axis = .horizontal
        segmentStackView.alignment = .fill
        segmentStackView.distribution = .fill
        segmentStackView.spacing = 0
        segmentStackView.addArrangedSubview(cpuSegment)
        segmentStackView.addArrangedSubview(gpuSegment)
        segmentStackView.addArrangedSubview(miscSegment)
        segmentStackView.addArrangedSubview(freeSegment)
        
        addSubview(segmentStackView)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(title)
        addSubview(valueLabel)
        addSubview(unitLabel)
        
        cpuSegment.backgroundColor = Theme.secondaryYellow
        cpuSegment.accessibilityIdentifier = "cpuSegment"

        gpuSegment.backgroundColor = Theme.highlightColor
        gpuSegment.accessibilityIdentifier = "gpuSegment"

        miscSegment.backgroundColor = Theme.secondaryGreen
        miscSegment.accessibilityIdentifier = "miscSegment"
        
        freeSegment.backgroundColor = Theme.frontColor
        freeSegment.accessibilityIdentifier = "freeSegment"
        
        cpuSegmentWidth = cpuSegment.widthAnchor.constraint(equalToConstant: bounds.width * 0.3)
        gpuSegmentWidth = gpuSegment.widthAnchor.constraint(equalToConstant: bounds.width * 0.3)
        miscSegmentWidth = miscSegment.widthAnchor.constraint(equalToConstant: bounds.width * 0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
        if segmentStackView.frame.height != 0 && segmentStackView.frame.width != 0 {
            deactivateSegmentWidths()
            activateSegmentWidths()
        }
        

    }
    
    func setLayout() {
        title.font = UIFont.systemFont(ofSize: bounds.width * GlobalConstants.barTitleHeightFactor, weight: .regular)
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * GlobalConstants.barValueHeightFactor * 0.75)
        unitLabel.font = UIFont.systemFont(ofSize: bounds.height * GlobalConstants.barValueHeightFactor * 0.75)
        
        labelLayout()

    }
    
    func labelLayout() {
        NSLayoutConstraint.deactivate(constraintsList)
        constraintsList = getConstraintList()
        NSLayoutConstraint.activate(constraintsList)
    }
    
    func getConstraintList() -> [NSLayoutConstraint] {
        let padding: CGFloat = bounds.height * GlobalConstants.barValueHeightFactor / 5
        
        return [
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor, constant: GlobalConstants.barPaddingFactor * bounds.height),
            
            valueLabel.trailingAnchor.constraint(equalTo: unitLabel.leadingAnchor, constant: -GlobalConstants.barPaddingFactor * bounds.height),
            valueLabel.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            
            unitLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            unitLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor),
            
            segmentStackView.widthAnchor.constraint(equalTo: widthAnchor),
            segmentStackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: padding),
            segmentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: GlobalConstants.barValueHeightFactor / 2),
        ]
    }
    
    
    func deactivateSegmentWidths(){
        cpuSegment.deactivateWidth()
        gpuSegment.deactivateWidth()
        miscSegment.deactivateWidth()
    }
    
    func activateSegmentWidths(){
        cpuSegmentWidth.isActive = true
        gpuSegmentWidth.isActive = true
        miscSegmentWidth.isActive = true
    }
}
