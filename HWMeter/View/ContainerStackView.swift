//
//  ContainerView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/3/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ContainerStackView: UIView {
    let viewmodel: ContainerStackViewModel = ContainerStackViewModel()
    
    let disposedBag: DisposeBag = DisposeBag()
    
    let stackView: UIStackView = UIStackView()
    
    let gaugeView: CustomGaugeView = CustomGaugeView(frame: .zero)
    let firstKPIView: KPIView = KPIView(frame: .zero)
    let secondKPIView: KPIView = KPIView(frame: .zero)
    
    let memoryView: BarView = BarView(frame: .zero)
    let fanView: MiniBarsView = MiniBarsView(frame: .zero)
    let spacer = UIView()
    
    var sensorType: SensorType = .CPU
    
//    var initialLoad: Bool = false {
//        didSet {
//            if initialLoad == true {
//                print("initialLoad is trigger")
//                configureSensorWidget()
//            }
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
//        print("ContainerStackView bounds Init: \(bounds)")
        
        configureStackView()
        
        if GlobalConstants.isDebug {
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 1
            
            gaugeView.layer.borderColor = UIColor.red.cgColor
            gaugeView.layer.borderWidth = 1
            
            firstKPIView.layer.borderColor = UIColor.red.cgColor
            firstKPIView.layer.borderWidth = 1
            
            secondKPIView.layer.borderColor = UIColor.orange.cgColor
            secondKPIView.layer.borderWidth = 1
            //            secondaryWidget.backgroundColor = UIColor.green
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(sensorType: SensorType) {
        super.init(frame: .zero)
        self.sensorType = sensorType
        
        translatesAutoresizingMaskIntoConstraints = false
//        print("ContainerStackView bounds Init: \(bounds)")
        
        configureStackView()
        
        if GlobalConstants.isDebug {
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 1
            
            gaugeView.layer.borderColor = UIColor.red.cgColor
            gaugeView.layer.borderWidth = 1
            
            firstKPIView.layer.borderColor = UIColor.red.cgColor
            firstKPIView.layer.borderWidth = 1
            
            secondKPIView.layer.borderColor = UIColor.orange.cgColor
            secondKPIView.layer.borderWidth = 1
            //            secondaryWidget.backgroundColor = UIColor.green
        }
        
    }
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
    }
    
    func configureSensorWidget() {
        addSubview(stackView)
        
        if sensorType != .GEN {
            stackView.addArrangedSubview(gaugeView)
            stackView.addArrangedSubview(firstKPIView)
            stackView.addArrangedSubview(secondKPIView)
            setupGaugeKPIView()
        } else {
            stackView.addArrangedSubview(spacer)
            stackView.addArrangedSubview(memoryView)
            stackView.addArrangedSubview(fanView)
            setupGeneralView()
        }
    }
    
    func setupGaugeKPIView() {
        gaugeKPIViewLayout()
        gaugeView.setup()
        firstKPIView.setUpLabel()
        secondKPIView.setUpLabel()
    }
    
    func gaugeKPIViewLayout() {
        NSLayoutConstraint.activate([
            gaugeView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: GlobalConstants.gaugeViewHeightFactor),
            firstKPIView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: (0.95 - GlobalConstants.gaugeViewHeightFactor)/2),
            gaugeView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            firstKPIView.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: GlobalConstants.kpiViewWidthFactor),
            
            secondKPIView.heightAnchor.constraint(equalTo: heightAnchor,
                                                  multiplier: (0.95 - GlobalConstants.gaugeViewHeightFactor)/2),
            secondKPIView.widthAnchor.constraint(equalTo: widthAnchor,
                                                 multiplier: GlobalConstants.kpiViewWidthFactor),
            
        ])
        
        layoutIfNeeded()
    }
    
    func setupGeneralView() {
        generalViewLayout()
        memoryView.setup()
        fanView.setup()
    }
    
    func generalViewLayout(){
        NSLayoutConstraint.activate([
            spacer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            spacer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            
            memoryView.heightAnchor.constraint(equalTo: heightAnchor,
                                               multiplier: GlobalConstants.barViewHeightFactor),
            memoryView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            fanView.heightAnchor.constraint(equalTo: heightAnchor,
                                            multiplier: 0.9 - GlobalConstants.barViewHeightFactor),
            fanView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
        ])
        layoutIfNeeded()
    }
    
    func setSensorInfoRX(observable: Observable<SensorGauge>) {
        observable.subscribe(onNext: { sensorInfo in
            self.gaugeView.sensorGauge = sensorInfo
            if sensorInfo.kpi.count > 1 {
                self.firstKPIView.kpiViewModel = sensorInfo.kpi[0]
                self.secondKPIView.kpiViewModel = sensorInfo.kpi[1]
            } else {
//                print(" sensorInfo is count is less than 2")
            }
        }).disposed(by: disposedBag)
    }
    
    func setMemoryDataRx(observable: Observable<SensorInfo>) {
        observable.subscribe(onNext: { memoInfo in
            self.memoryView.barViewModel = BarViewModel(sensorInfo: memoInfo)
        }).disposed(by: disposedBag)
    }
    
    func setFanDataRx(observable: Observable<FanInfo>) {
        observable.subscribe(onNext: { fanInfoList in
            self.fanView.miniBarViewModel = fanInfoList
        }).disposed(by: disposedBag)
    }
}
