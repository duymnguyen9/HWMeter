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
    let disposedBag: DisposeBag = DisposeBag()
    
    let stackView: UIStackView = UIStackView()
    
    let gaugeView: CustomGaugeView = CustomGaugeView(frame: .zero)
    let firstKPIView: KPIView = KPIView(frame: .zero)
    let secondKPIView: KPIView = KPIView(frame: .zero)
    let kpiStackView : KPIStackView = KPIStackView(frame: .zero)
    
    let memoryView: BarView = BarView(frame: .zero)
    let fanView: MiniBarsView = MiniBarsView(frame: .zero)
    let spacer = UIView()
    
    var sensorType: SensorType = .CPU
    let containerView = UIView(frame: .zero)
    
    let paddingFactor : CGFloat = 0.85
    
    var gaugeViewConstraints : [NSLayoutConstraint] = [NSLayoutConstraint]()
    var generalViewConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
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
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        configureStackView()
        
        containerView.addSubview(stackView)
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            containerView.leftAnchor.constraint(equalTo: leftAnchor),
//            containerView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        if sensorType != .GEN {
            containerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//            gaugeViewConstraints = configureGaugeConstraintPortrait()
//            NSLayoutConstraint.activate(gaugeViewConstraints)
            stackView.addArrangedSubview(gaugeView)
            stackView.addArrangedSubview(kpiStackView)
        } else {
            //            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: paddingFactor ).isActive = true
            stackView.axis = .horizontal
//            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: paddingFactor ).isActive = true
            stackView.addArrangedSubview(memoryView)
            stackView.addArrangedSubview(fanView)
            generalViewConstraints = getGeneralViewConstraintsPortrait()
            NSLayoutConstraint.activate(generalViewConstraints)
        }
        
        if GlobalConstants.isDebug {
            layer.borderColor = UIColor.yellow.cgColor
            layer.borderWidth = 1
            
            gaugeView.layer.borderColor = UIColor.blue.cgColor
            gaugeView.layer.borderWidth = 1
            
            firstKPIView.layer.borderColor = UIColor.red.cgColor
            firstKPIView.layer.borderWidth = 1
            
            secondKPIView.layer.borderColor = UIColor.orange.cgColor
            secondKPIView.layer.borderWidth = 1
            //            secondaryWidget.backgroundColor = UIColor.green
        }
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSensorWidget()
    }
    
    func getGaugeConstraintPortrait() -> [NSLayoutConstraint] {
        return [
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            
            gaugeView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: GlobalConstants.gaugeViewHeightFactor),
            gaugeView.widthAnchor.constraint(equalTo: widthAnchor),
            kpiStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: GlobalConstants.kpiViewWidthFactor),
            kpiStackView.heightAnchor.constraint(equalTo: heightAnchor,
                                                 multiplier: (0.95 - GlobalConstants.gaugeViewHeightFactor)),

        ]
    }
    
    func getGaugeConstraintsLandscape() -> [NSLayoutConstraint] {
        return [
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            
            gaugeView.heightAnchor.constraint(equalTo: heightAnchor),
            gaugeView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: GlobalConstants.gaugeViewHeightFactor),
            kpiStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            kpiStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: GlobalConstants.kpiViewWidthFactor),
            
        ]
    }
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
//        stackView.spacing = 10
        
    }
    
    func configureSensorWidget() {
        if sensorType != .GEN {

            gaugeKPIViewLayout()
        } else {
            containerView.backgroundColor = Theme.backgroundColor
            containerView.layer.cornerRadius = 10

            generalViewLayout()
        }
    }
    
    func gaugeKPIViewLayout() {
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .vertical
            NSLayoutConstraint.deactivate(gaugeViewConstraints)
            gaugeViewConstraints = getGaugeConstraintPortrait()
            NSLayoutConstraint.activate(gaugeViewConstraints)
        } else {
            stackView.axis = .horizontal
            
            NSLayoutConstraint.deactivate(gaugeViewConstraints)
            gaugeViewConstraints = getGaugeConstraintsLandscape()
            NSLayoutConstraint.activate(gaugeViewConstraints)
        }
    }
    
    func generalViewLayout(){
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .vertical
            NSLayoutConstraint.deactivate(generalViewConstraints)
            generalViewConstraints = getGeneralViewConstraintsLandscape()
            NSLayoutConstraint.activate(generalViewConstraints)
        } else {
            stackView.axis = .vertical
            NSLayoutConstraint.deactivate(generalViewConstraints)
            generalViewConstraints = getGeneralViewConstraintsPortrait()
            NSLayoutConstraint.activate(generalViewConstraints)
        }
    }
    
    func getGeneralViewConstraintsLandscape() -> [NSLayoutConstraint]{
        return [
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: paddingFactor ),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            memoryView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                               multiplier: GlobalConstants.barViewHeightFactor),
            memoryView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
            fanView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                            multiplier: 0.9 - GlobalConstants.barViewHeightFactor),
            fanView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
        ]
    }
    
    func getGeneralViewConstraintsPortrait() -> [NSLayoutConstraint]{
        return [
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.95),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            memoryView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                               multiplier: GlobalConstants.barViewHeightFactor),
            memoryView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
            fanView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                            multiplier: 0.95 - GlobalConstants.barViewHeightFactor),
            fanView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
        ]
    }
    
    
    func setSensorInfoRX(observable: Observable<SensorGauge>) {
        observable.subscribe(onNext: { sensorInfo in
            self.gaugeView.sensorGauge = sensorInfo
            if sensorInfo.kpi.count > 1 {
//                self.firstKPIView.kpiViewModel = sensorInfo.kpi[0]
//                self.secondKPIView.kpiViewModel = sensorInfo.kpi[1]
                self.kpiStackView.KPIStackViewSensors = sensorInfo.kpi
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
