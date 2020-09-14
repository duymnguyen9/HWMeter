//import RxCocoa
//import RxSwift
//import UIKit
//
//class MainViewController: UIViewController {
//    let stackView = UIStackView()
//    
//    let sensorView: ContainerStackView = ContainerStackView(frame: .zero)
//    
//    let cpuView: ContainerStackView = ContainerStackView(sensorType: .CPU)
//    let gpuView: ContainerStackView = ContainerStackView(sensorType: .GPU)
//    let generalView: ContainerStackView = ContainerStackView(sensorType: .GEN)
//    
//    var initialLayout: Bool = true
//    
//    var sensorDataCheck: Disposable = {
//        print("Started Timer")
//        return Observable<Int>.interval(.seconds(2), scheduler: SerialDispatchQueueScheduler(qos: .utility)).subscribe { _ in
//            DispatchQueue.global(qos: .utility).async {
//                if GlobalConstants.useTestData {
//                    SensorDataService.sensorDataService.readLocalFile()
//                } else {
//                    SensorDataService.sensorDataService.getSensorDataFromURL()
//                }
//            }
//        }
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        UIApplication.shared.isIdleTimerDisabled = true
//        
//        view.backgroundColor = Theme.blackBackGroundColor
//        view.addSubview(stackView)
//        configureStackView()
//                
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
//        stackView.frame = view.safeAreaLayoutGuide.layoutFrame
//
//    }
//    
//    
//    func configureStackView() {
//        stackView.alignment = .fill
//        stackView.distribution = .fillEqually
//        stackView.axis = .horizontal
//            
//        stackView.addArrangedSubview(cpuView)
//        stackView.addArrangedSubview(gpuView)
//        stackView.addArrangedSubview(generalView)
//        
//        cpuView.setSensorInfoRX(observable: SensorDataService.sensorDataService.cpuDataSubject.asObservable())
//        
//        gpuView.setSensorInfoRX(observable: SensorDataService.sensorDataService.gpuDataSubject.asObservable())
//        
//        generalView.setMemoryDataRx(
//            observable: SensorDataService.sensorDataService.memoryDataSubject.asObservable())
//        generalView.setFanDataRx(
//            observable: SensorDataService.sensorDataService.fanDataSubject.asObservable())
//    }
//}
//
