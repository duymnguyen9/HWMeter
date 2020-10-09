//
//  MainViewController.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/3/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MainViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    
    let stackView = UIStackView()
        
    let cpuView: ContainerStackView = ContainerStackView(sensorType: .CPU)
    let gpuView: ContainerStackView = ContainerStackView(sensorType: .GPU)
    var stackViewContraints : [NSLayoutConstraint] = [NSLayoutConstraint]()
            
    var sensorDataCheck: Disposable = {
        print("Started Timer")
        DispatchQueue.global(qos: .utility).async {
            SensorDataService.service.retrieveDataFromHost()
        }
        return Observable<Int>.interval(.seconds(2), scheduler: SerialDispatchQueueScheduler(qos: .utility)).subscribe { _ in
            DispatchQueue.global(qos: .utility).async {      
                SensorDataService.service.retrieveDataFromHost()
            }
        }
    }()
    
    let swipableViewController : SwipeableViewController = SwipeableViewController()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UIApplication.shared.isIdleTimerDisabled = true
        
        cpuView.accessibilityIdentifier = "CPU_View"
        gpuView.accessibilityIdentifier = "GPU_View"
        stackView.accessibilityIdentifier = "Main_StackView"
        
        view.backgroundColor = Theme.blackBackGroundColor
        view.addSubview(stackView)
        configureStackView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        stackView.frame = view.safeAreaLayoutGuide.layoutFrame
        layoutWhenRotate()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        screenOrientationLayout()
    }
    
    
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        addChild(swipableViewController)
            
        stackView.addArrangedSubview(cpuView)
        stackView.addArrangedSubview(gpuView)
        stackView.addArrangedSubview(swipableViewController.view)
        
        stackViewContraints = getConstraintListPortrait()
        NSLayoutConstraint.activate(stackViewContraints)

        
    }
    
    func screenOrientationLayout(){
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .fill

            NSLayoutConstraint.deactivate(stackViewContraints)
            
        } else {
            
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill

        }
    }
    
    func getConstraintListPortrait() -> [NSLayoutConstraint] {
        return [
            
            cpuView.heightAnchor.constraint(equalTo: stackView.heightAnchor,
                                            multiplier: 0.3),
            gpuView.heightAnchor.constraint(equalTo: cpuView.heightAnchor),
        ]
    }
    
    func getConstraintListLandscape() -> [NSLayoutConstraint] {
        return [
            cpuView.widthAnchor.constraint(equalTo: stackView.widthAnchor,
                                           multiplier: 0.30),
            gpuView.widthAnchor.constraint(equalTo: stackView.widthAnchor,
                                           multiplier: 0.30),
        ]
    }
    
    func layoutWhenRotate() {
        if UIDevice.current.orientation.isPortrait && stackView.bounds.height >= stackView.bounds.width {
            NSLayoutConstraint.deactivate(stackViewContraints)
            stackViewContraints = getConstraintListPortrait()
            NSLayoutConstraint.activate(stackViewContraints)
        } else if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate(stackViewContraints)
            stackViewContraints = getConstraintListLandscape()
            NSLayoutConstraint.activate(stackViewContraints)
        }
    }

}
