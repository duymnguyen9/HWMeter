//
//  KPIStackView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/10/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

class KPIStackView : UIView {
    var KPIStackViewSensors : [SensorInfo] = [SensorInfo]() {
        didSet {
            firstKPIView.kpiViewModel = KPIStackViewSensors[0]
            secondKPIView.kpiViewModel = KPIStackViewSensors[1]
        }
    }
    
    let stackView = UIStackView()
    
    let firstKPIView: KPIView = KPIView(frame: .zero)
    let secondKPIView: KPIView = KPIView(frame: .zero)
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.addArrangedSubview(firstKPIView)
        stackView.addArrangedSubview(secondKPIView)
        
        addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
//        stackView.frame = bounds
        print("kpi stackview bounds: \(stackView.frame)")
        super.layoutSubviews()
//        kpi stackview bounds: (0.0, 0.0, 269.0, 136.5)
        stackView.frame = bounds
        print("kpi stackview bounds: \(stackView.frame)")
        
    }
    
}
