//
//  ConfigurationViewController.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/15/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConfigurationViewController: UIViewController, UITextFieldDelegate, Storyboarded {
    
    let pageTitle : UILabel = UILabel()
    let ipTextField : UITextField = UITextField()
    let portTextField : UITextField = UITextField()
    let connectButton : HMButton = HMButton()
    let useTestDataButton : HMButton = HMButton()
    let contentView : UIView = UIView()
    var keyboardPadding : CGFloat = 0
    let disposeBag = DisposeBag()
        
    weak var coordinator: MainCoordinator?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.backgroundColor = UIColor.darkGray
        contentView.addSubview(pageTitle)
        contentView.addSubview(ipTextField)
        contentView.addSubview(portTextField)
        contentView.addSubview(connectButton)
        contentView.addSubview(useTestDataButton)
        
        view.addSubview(contentView)
        
        view.backgroundColor = Theme.secondaryBlack
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configurePageTitle()
        configureLayoutConstraint()
        
        configureIpTextField()
        configurePortTextField()
        configureConnectButton()
        configureUseTestDataButton()
        
        configureDebug()
        
        ipTextField.text = "192.168.1.17"
        portTextField.text = "55555"
        
        SensorDataService.service.ipAddressSubject.asObservable().subscribe(onNext: { (urlString) in
            if urlString.count > 10 || urlString == "testData" {
                self.coordinator?.connectToMainController()
            }
        }).disposed(by: disposeBag)
        
        SensorDataService.service.useTestDataSubject.asObservable().subscribe(onNext: {(isTestData) in
            if isTestData {
                self.coordinator?.connectToMainController()
            }
            }).disposed(by: disposeBag)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print(view.bounds)
//        print(pageTitle.bounds)
//        print(contentView.frame)
    }
    
    func configurePageTitle() {
        pageTitle.text = "DataSource"
        pageTitle.textAlignment = .left
        pageTitle.font = .systemFont(ofSize: 35, weight: .medium)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.accessibilityIdentifier = "pageTitle"
        pageTitle.textColor = UIColor.white.withAlphaComponent(0.87)
    }
    
    func configureIpTextField() {
        ipTextField.delegate = self
        ipTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 22))
        ipTextField.leftViewMode = .always
        
        ipTextField.accessibilityIdentifier = "ipTextField"
        ipTextField.translatesAutoresizingMaskIntoConstraints = false
        ipTextField.placeholder = "IP Host"
        ipTextField.textColor = UIColor.white.withAlphaComponent(0.6)
        ipTextField.backgroundColor = Theme.backgroundColor
        
        ipTextField.attributedPlaceholder = NSAttributedString(string: "IP Host",
                                                               attributes: [NSAttributedString.Key.foregroundColor : Theme.frontColor])
        
        ipTextField.font = .systemFont(ofSize: 25, weight: .regular)
        ipTextField.layer.cornerRadius = 5
        ipTextField.layer.masksToBounds = true
    }
    
    func configurePortTextField() {
        portTextField.delegate = self
        portTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 22))
        portTextField.leftViewMode = .always
        
        portTextField.translatesAutoresizingMaskIntoConstraints = false
        portTextField.accessibilityIdentifier = "portTextField"

        portTextField.placeholder = "Port #"
        portTextField.textColor = .orange
        portTextField.backgroundColor = Theme.backgroundColor
        portTextField.font = .systemFont(ofSize: 25, weight: .regular)
        portTextField.layer.cornerRadius = 5
         portTextField.layer.masksToBounds = true
        portTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 22))
        
        portTextField.attributedPlaceholder = NSAttributedString(string: "Port #",
                                                               attributes: [NSAttributedString.Key.foregroundColor : Theme.frontColor])
        portTextField.textColor = UIColor.white.withAlphaComponent(0.6)
    }
    
    
    
    func configureConnectButton() {
        connectButton.accessibilityIdentifier = "connectButton"
        connectButton.setTitle("CONNECT", for: .normal)
        connectButton.setTitle("VERIFYING", for: .disabled)
        connectButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)

        connectButton.backgroundColor = Theme.highlightColor
        connectButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.setTitleColor(.white, for: .normal)
        
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
    }
    
    func configureUseTestDataButton() {
        useTestDataButton.accessibilityIdentifier = "useTestDataButton"
        useTestDataButton.setTitle("TEST DATA", for: .normal)
        
        useTestDataButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        useTestDataButton.setTitleColor(Theme.highlightColor, for: .normal)
        useTestDataButton.layer.borderWidth = 2
        useTestDataButton.layer.borderColor = Theme.highlightColor.cgColor
        useTestDataButton.translatesAutoresizingMaskIntoConstraints = false
        
        useTestDataButton.addTarget(self, action: #selector(testDataButtonPressed), for: .touchUpInside)
    }
    
    @objc func connectButtonPressed(){
        if ipTextField.canResignFirstResponder {
            ipTextField.resignFirstResponder()
        } else {
            portTextField.resignFirstResponder()
        }
        
        connectButton.setBackgroundAlpha(0.5)
        connectButton.isEnabled = false
        if verifyTextField() {
                    if let ipText = ipTextField.text, let portText = portTextField.text {
                        DispatchQueue.global(qos: .utility).async {
                            SensorDataService.service.verifyHost(ipText, portText)
                        }
            }
        } else {
            
            
            connectButton.backgroundColor = Theme.secondaryPurple
            connectButton.isEnabled = true
            showFailedToConnectAlert()
        }
        
    }
    
    @objc func testDataButtonPressed(){
        if ipTextField.canResignFirstResponder {
            ipTextField.resignFirstResponder()
        } else {
            portTextField.resignFirstResponder()
        }
        
        SensorDataService.service.setTestData()
    }
    
    func showFailedToConnectAlert() {
        print("showFailedToConnectAlert")
        
        let message = "\n IP Host or Port are not correct \n example: \n Host: 192.168.1.99 \n Port: 55555"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)
            ]
        )
        
        let alertTitle = "Failed to Connect"
        
        let titleText = NSMutableAttributedString(
            string: alertTitle,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0)
            ]
        )
        
        
        let alert = UIAlertController(title: alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.setValue(messageText, forKey: "attributedMessage")
        alert.setValue(titleText, forKey: "attributedTitle")

        self.present(alert, animated: true, completion: nil)
    }
    
    func verifyTextField() -> Bool {
        if let ipText = ipTextField.text, let portText = portTextField.text {
            if ipText.count < 12 && portText.count != 5 {
                return false
            }
        }
        return true
    }
    

    func configureLayoutConstraint() {
        let contentWidthFactor : CGFloat = 0.8
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 550),
            
            contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: contentWidthFactor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            pageTitle.bottomAnchor.constraint(equalTo: ipTextField.topAnchor, constant: -30),
            pageTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
  
            ipTextField.bottomAnchor.constraint(equalTo: portTextField.topAnchor, constant: -25),
            ipTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ipTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            ipTextField.heightAnchor.constraint(equalToConstant: 50),
            
            portTextField.bottomAnchor.constraint(equalTo: useTestDataButton.topAnchor, constant: -40),
            portTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            portTextField.heightAnchor.constraint(equalToConstant: 50),
            
            useTestDataButton.bottomAnchor.constraint(equalTo: connectButton.bottomAnchor),
            useTestDataButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            useTestDataButton.leadingAnchor.constraint(equalTo: portTextField.leadingAnchor),
            useTestDataButton.heightAnchor.constraint(equalToConstant: 70),
            
            connectButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            connectButton.trailingAnchor.constraint(equalTo: portTextField.trailingAnchor),
            connectButton.heightAnchor.constraint(equalToConstant: 70),
            connectButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -100)
        }
    }
    
    @objc func keyboardWillHide(notificaiton: NSNotification){
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureDebug() {
            if GlobalConstants.isDebug {
                view.layer.borderColor = UIColor.orange.cgColor
                view.layer.borderWidth = 3
                
                pageTitle.layer.borderColor = UIColor.red.cgColor
                 ipTextField.layer.borderColor = UIColor.blue.cgColor
                 portTextField.layer.borderColor = UIColor.yellow.cgColor
//                 submitButton.layer.borderColor = UIColor.green.cgColor
//                 useTestDataButton.layer.borderColor = UIColor.purple.cgColor
                
                pageTitle.layer.borderWidth = 2
                 ipTextField.layer.borderWidth = 2
                 portTextField.layer.borderWidth = 2
//                 submitButton.layer.borderWidth = 2
//                 useTestDataButton.layer.borderWidth = 2
    //            pageTitle
    //            ipTextField
    //            portTextField
    //            submitButton
    //            useTestDataButton
            }
        }
    
    
}
