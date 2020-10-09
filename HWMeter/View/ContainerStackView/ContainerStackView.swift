//
//  ContainerView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/3/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import RxSwift
import UIKit

class ContainerStackView: UIView {
    let disposedBag: DisposeBag = DisposeBag()
    
    let stackView: UIStackView = UIStackView()
    
    let gaugeView: CustomGaugeView = CustomGaugeView(frame: .zero)
    let kpiStackView: KPIStackView = KPIStackView(frame: .zero)
    
    let memoryView: BarView = BarView(frame: .zero)
    let fanView: MiniBarsView = MiniBarsView(frame: .zero)
    
    // PowerView Views
    let totalPowerView: StackBarView = StackBarView(frame: .zero)
    let powerKPIView: KPITableView = KPITableView(frame: .zero)
    
    var sensorType: SensorType = .CPU
    let containerView = UIView(frame: .zero)
    
    let paddingFactor: CGFloat = 0.85
    
    var gaugeViewConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var generalViewConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var powerViewConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureStackView()
        if GlobalConstants.isDebug {
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 1
            
            gaugeView.layer.borderColor = UIColor.red.cgColor
            gaugeView.layer.borderWidth = 1
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
        ])
        
        switch sensorType {
        case .GEN:
            containerView.backgroundColor = Theme.backgroundColor
            containerView.layer.cornerRadius = 10
            stackView.axis = .vertical
            stackView.addArrangedSubview(memoryView)
            stackView.addArrangedSubview(fanView)
        case .POWER:
            containerView.backgroundColor = Theme.backgroundColor
            containerView.layer.cornerRadius = 10
            stackView.axis = .vertical
            stackView.addArrangedSubview(totalPowerView)
            stackView.addArrangedSubview(powerKPIView)
        case .CPU, .GPU:
            containerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            stackView.addArrangedSubview(gaugeView)
            stackView.addArrangedSubview(kpiStackView)
        }
        
        setRXData(sensorType)
        
        if GlobalConstants.isDebug {
            layer.borderColor = UIColor.yellow.cgColor
            layer.borderWidth = 1
            
            gaugeView.layer.borderColor = UIColor.blue.cgColor
            gaugeView.layer.borderWidth = 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSensorWidget()
    }
    
    func configureSensorWidget() {
        if bounds.height == 0, bounds.width == 0 {
            return
        }
        
        
        switch sensorType {
        case .GEN:
            generalViewLayout()
        case .POWER:
            powerViewLayout()
        case .CPU, .GPU:
            gaugeKPIViewLayout()
        }
        
    }
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
    }
}

// MARK: - RX Setup

extension ContainerStackView {
    
    func setRXData(_ sensorType: SensorType){
        let service = SensorDataService.service
        switch sensorType {
        case .CPU:
            service.cpuDataOuput().subscribe(onNext: { sensorInfo in
                self.gaugeView.sensorGauge = sensorInfo
                if sensorInfo.kpi.count > 1 {
                    self.kpiStackView.KPIStackViewSensors = sensorInfo.kpi
                }
            }).disposed(by: disposedBag)
            
        case .GPU:
            service.gpuDataOutput().subscribe(onNext: { sensorInfo in
                self.gaugeView.sensorGauge = sensorInfo
                if sensorInfo.kpi.count > 1 {
                    self.kpiStackView.KPIStackViewSensors = sensorInfo.kpi
                }
            }).disposed(by: disposedBag)
        case .GEN:
            service.memoryDataOutput().subscribe(onNext: { memoInfo in
                self.memoryView.barViewModel = BarViewModel(sensorInfo: memoInfo)
            }).disposed(by: disposedBag)
            service.fanDataOutput().subscribe(onNext: { fanInfoList in
                self.fanView.miniBarViewModel = fanInfoList
            }).disposed(by: disposedBag)
        case .POWER:
            service.powerDataOutput().subscribe(onNext: { power in
                self.totalPowerView.viewModel = StackBarViewModel(data: power, psuRating: 650)
                self.powerKPIView.viewmodel = power
            }).disposed(by: disposedBag)
        }
    }
    
}
