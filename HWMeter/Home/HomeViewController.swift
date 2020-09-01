//
//  ViewController.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    var sensorDataCheck : Disposable?
    
    func homeViewModelRX() -> Observable<HomeViewModel>{
        return Observable.combineLatest(
            SensorDataService.sensorDataService.cpuDataSubject.asObservable(),
            SensorDataService.sensorDataService.gpuDataSubject.asObservable()){
                (cpuData, gpuData) in
                
                print("cpuData : \(cpuData)")
                print("gpuData : \(gpuData)")
                
                var sensorList : [CollectionCellViewModel] = []
                sensorList.append(CollectionCellViewModel(sensorGauge: cpuData))
                sensorList.append(CollectionCellViewModel(sensorGauge: gpuData))
                return HomeViewModel(cellViewModels: sensorList)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        sensorDataCheck = Observable<Int>.interval(.seconds(2), scheduler: SerialDispatchQueueScheduler.init(qos: .utility)).subscribe { (target) in
            DispatchQueue.global(qos: .utility).async {
                print("timer ")
                
                                SensorDataService.sensorDataService.readLocalFile()
//                SensorDataService.sensorDataService.getSensorDataFromURL()
            }
        }
        
        
        
        self.view.backgroundColor = Theme.secondaryBlack
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionViewLayoutSetup()
    }
    
    func collectionViewLayoutSetup(){
//        collectionView.backgroundColor = Theme.backgroundColor
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
    }
    
    
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = Theme.frontColor
        cell.setSensorInfoRX(
            observable: SensorDataService.sensorDataService.cpuDataSubject.asObservable())
        cell.sensorView.gradient.colors = Theme.gradientColors3
        
        
        //        if indexPath.row == 0 {
        //            print("set observable for CPU View")
        //            cell.setSensorInfoRX(
        //            observable: SensorDataService.sensorDataService.cpuDataSubject.asObservable())
        //            cell.sensorView.gradient.colors = Theme.gradientColors3
        //        } else if indexPath.row == 1 {
        //            print("set observable for GPU View")
        //            cell.setSensorInfoRX(
        //            observable: SensorDataService.sensorDataService.gpuDataSubject.asObservable())
        //            cell.sensorView.gradient.colors = Theme.gradientColors2
        //        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = (collectionView.bounds.width - 40) / 3
        let cellSize = CGSize(width: width, height: collectionView.frame.height * 0.95)
        LayoutConfig.sharedConfig.cellSize.onNext(cellSize)
        return cellSize
    }
}


extension HomeViewController : UICollectionViewDelegate {
    
}
