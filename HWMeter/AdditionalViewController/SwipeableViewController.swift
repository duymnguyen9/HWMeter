//
//  SwipeableViewController.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/7/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit
import Gemini
import RxSwift


class SwipeableViewController: UIViewController {
    let generalView: ContainerStackView = ContainerStackView(sensorType: .GEN)
    let powerView: ContainerStackView = ContainerStackView(sensorType: .POWER)
    var pageControlIndicator: UIPageControl = UIPageControl(frame: .zero)
    
    let layout : SnappingCollectionViewLayout = SnappingCollectionViewLayout()

    
    var collectionView : GeminiCollectionView = {
        let view = GeminiCollectionView(frame: .zero, collectionViewLayout: SnappingCollectionViewLayout.init())
        return view
    }()
    
    var atInitialCell : Bool = false
            
    override func viewDidLoad() {
        super.viewDidLoad()
        generalView.accessibilityIdentifier = "GEN_View"
        powerView.accessibilityIdentifier = "POW_View"
        
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        collectionView.register(SwipeableViewCell.self, forCellWithReuseIdentifier: "SwipeableViewCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        configureAnimation()
        
        pageControlSetup()

        view.addSubview(collectionView)
        view.addSubview(pageControlIndicator)
        
//        collectionView.layer.borderColor = UIColor.orange.cgColor
//        collectionView.layer.borderWidth = 3
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLayout()
        
        guard let flowLayout = collectionView.collectionViewLayout as? SnappingCollectionViewLayout else {
          return
        }
        powerView.layoutIfNeeded()
        generalView.layoutIfNeeded()
        flowLayout.invalidateLayout()
        print("pageCOntrol frame: \(pageControlIndicator.frame)")

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        

        
        // Have the collection view re-layout its cells.
        coordinator.animate(
            alongsideTransition: { _ in self.collectionView.collectionViewLayout.invalidateLayout() },
            completion: { _ in }
        )
    }
    
    func setLayout() {
        NSLayoutConstraint.activate([
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant:  -40),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),

            pageControlIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pageControlIndicator.leadingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -5),
        ])
    }
    
    // Configure animation and properties
    func configureAnimation() {
        collectionView.gemini
            .scaleAnimation()
            .scale(0.75)
            .scaleEffect(.scaleUp)
    }
    
    func pageControlSetup() {
        pageControlIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageControlIndicator.numberOfPages = 2
        pageControlIndicator.currentPage = 1
        pageControlIndicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75).translatedBy(x: -55, y: 0).rotated(by: .pi/2)
    }
    
    // Call animation function
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControlIndicator.currentPage = Int(scrollView.contentOffset.y) / Int(scrollView.frame.height)
    }
}


extension SwipeableViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipeableViewCell", for: indexPath) as! SwipeableViewCell
        
        if indexPath.row % 2 == 1 {
            cell.setCardView(powerView)
        } else {
            cell.setCardView(generalView)
        }
        
        self.collectionView.animateCell(cell)
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        self.pageControlIndicator.currentPage = indexPath.row
        if let cell = cell as? GeminiCell {
            self.collectionView.animateCell(cell)
        }
    }
    
}

extension SwipeableViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewCellSize()
    }
    
    
    func collectionViewCellSize() -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        } else {
            return CGSize(width: collectionView.bounds.width * 0.9, height: collectionView.bounds.height)
        }
    }
}
