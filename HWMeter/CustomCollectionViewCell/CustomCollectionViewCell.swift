//
//  CustomCollectionViewCell.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum ViewType {
    case Standard
    case Secondary
}

class CustomCollectionViewCell: UICollectionViewCell {
    var sensorInfo: Observable<SensorGauge>?
    
    var memoryInfo: Observable<SensorInfo>?
    
    let disposedBag: DisposeBag = DisposeBag()
    
    var viewType: ViewType = ViewType.Standard {
        willSet {
            if viewType == .Secondary {}
        }
    }
    
    let barView: BarView = {
        var size = CGSize(width: 100, height: 100)
        do {
            try size = LayoutConfig.sharedConfig.cellSize.value()
        } catch {
            print(error)
        }
        let sensorSize = CGSize(width: size.width * GlobalConstants.barViewSizeFactor,
                                height: size.height * GlobalConstants.barViewHeightFactor * GlobalConstants.barViewSizeFactor)
        let viewFrame = CGRect(origin: .zero, size: sensorSize)
        let view = BarView(frame: viewFrame)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sensorView: CustomGaugeView = {
        var size = CGSize(width: 100, height: 100)
        do {
            try size = LayoutConfig.sharedConfig.cellSize.value()
            print(size)
        } catch {
            print(error)
        }
        let sensorSize = CGSize(width: size.width, height: size.height * GlobalConstants.gaugeViewHeightFactor)
        
        let viewFrame = CGRect(origin: .zero, size: sensorSize)
        
        let view = CustomGaugeView(frame: viewFrame)
        view.sensorGauge = SensorGauge(temp: "50", usage: 0.2, sensorType: .CPU)
        //        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let kpiView: KPIView = {
        var size = CGSize(width: 100, height: 100)
        do {
            try size = LayoutConfig.sharedConfig.cellSize.value()
            print(size)
        } catch {
            print(error)
        }
        let sensorSize = CGSize(width: size.width * 0.8,
                                height: size.height * (1 - GlobalConstants.gaugeViewHeightFactor) / 2)
        
        let viewFrame = CGRect(origin: .zero, size: sensorSize)
        
        let view = KPIView(frame: viewFrame)
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = Theme.frontColor
        return view
    }()
    
    let secondaryKpiView: KPIView = {
        var size = CGSize(width: 100, height: 100)
        do {
            try size = LayoutConfig.sharedConfig.cellSize.value()
            print(size)
        } catch {
            print(error)
        }
        let sensorSize = CGSize(width: size.width * 0.8, height: size.height * (1 - GlobalConstants.gaugeViewHeightFactor) / 2)
        
        let viewFrame = CGRect(origin: CGPoint(x: 0, y: size.height * GlobalConstants.gaugeViewHeightFactor / 2), size: sensorSize)
        
        let view = KPIView(frame: viewFrame)
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.layer.backgroundColor = Theme.secondaryRed.cgColor
        
        view.kpiViewModel = SensorInfo(title: "secondary", value: "XX.XX", unit: "GHz")
        //        view.layer.borderColor = Theme.secondaryRed.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        if GlobalConstants.isDebug {
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.orange.cgColor
        } else {}
        //        viewSetup()
//        secondaryViewSetup()
    }
    
    init(isSecondary: Bool) {
        super.init(frame: .zero)
        //        if isSecondary {
        //            secondaryViewSetup()
        //        }
//        secondaryViewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewSetup() {
        contentView.addSubview(sensorView)
        contentView.addSubview(kpiView)
        contentView.addSubview(secondaryKpiView)
        
        NSLayoutConstraint.activate([
            sensorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            sensorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sensorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sensorView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: GlobalConstants.gaugeViewHeightFactor),
            
            kpiView.topAnchor.constraint(equalTo: sensorView.bottomAnchor),
            kpiView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            kpiView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            kpiView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: (1 - GlobalConstants.gaugeViewHeightFactor) / 2),
            
            secondaryKpiView.topAnchor.constraint(equalTo: kpiView.bottomAnchor),
            secondaryKpiView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            secondaryKpiView.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondaryKpiView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: (1 - GlobalConstants.gaugeViewHeightFactor) / 2),
        ])
    }
    
    func secondaryViewSetup() {
        contentView.addSubview(barView)
        
        var size = CGSize(width: 100, height: 100)
        do {
            try size = LayoutConfig.sharedConfig.cellSize.value()
        } catch {
            print(error)
        }
        
        let marginY = size.height * (1 - GlobalConstants.barViewSizeFactor) / 2
        let marginX = size.width * (1 - GlobalConstants.barViewSizeFactor) / 2
        
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                         constant: marginY),
            barView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                             constant: marginX),
            barView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setSensorInfoRX(observable: Observable<SensorGauge>) {
        observable.subscribe(onNext: { sensorInfo in
            self.sensorView.sensorGauge = sensorInfo
            if sensorInfo.kpi.count > 1 {
                self.kpiView.kpiViewModel = sensorInfo.kpi[0]
                self.secondaryKpiView.kpiViewModel = sensorInfo.kpi[1]
            } else {
                print(" sensorInfo is count is less than 2")
            }
        }).disposed(by: disposedBag)
    }
    
    func setMemoryDataRx(observable: Observable<SensorInfo>) {
        observable.subscribe(onNext: { memoInfo in
            self.barView.barViewModel = BarViewModel(sensorInfo: memoInfo)
        }).disposed(by: disposedBag)
    }
}
