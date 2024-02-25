//
//  TabBarVCViewController.swift
//  Bazar
//
//  Created by iOSayed on 11/09/2023.
//

import UIKit
import WoofTabBarController

class TabBarVC: UITabBarController {
    //MARK: - Lifecycle
        let homeVC = HomeNavigationController.instantiate()
        let storesVC = StoreNavigationController.instantiate()
        let addAdsVC = AddAddNavigationController.instantiate()
        let categoryVC = CategoryNavigationController.instantiate()
        let menuVC = ProfileNavigationController.instantiate()
    
    var centerButton = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptabBarAppearance()
        view.backgroundColor = .white
        setupTabItems()
        
    }
    
 
    private func setupTabItems(){
        homeVC.tabBarItem.selectedImage = UIImage(named: "HomeButtonIcon")?.withTintColor(UIColor(named: "#0EBFB1") ?? .yellow, renderingMode: .alwaysOriginal).resized(to: CGSize(width: 25, height: 25))
        homeVC.tabBarItem.image = UIImage(named: "home")?.withTintColor(.gray.withAlphaComponent(0.7), renderingMode: .alwaysOriginal).resized(to: CGSize(width: 20, height: 20))
        homeVC.title = "Home".localize
        storesVC.tabBarItem.selectedImage = UIImage(named: "Institutions")?.withTintColor(UIColor(named: "#0EBFB1") ?? .yellow, renderingMode: .alwaysOriginal).resized(to: CGSize(width: 25, height: 25))
        storesVC.tabBarItem.image = UIImage(named: "Institutions")?.withTintColor(.gray.withAlphaComponent(0.7), renderingMode: .alwaysOriginal).resized(to: CGSize(width: 20, height: 20))
        storesVC.title = "Institutions".localize
        addAdsVC.tabBarItem.selectedImage = UIImage(named: "AddAdsIconMain")?.withTintColor(UIColor(named: "#0EBFB1") ?? .yellow, renderingMode: .alwaysOriginal).resized(to: CGSize(width: 25, height: 25))
        addAdsVC.tabBarItem.image = UIImage(named: "addAdvsButtonIconGray")?.withTintColor(.gray.withAlphaComponent(0.7), renderingMode: .alwaysOriginal).resized(to: CGSize(width: 20, height: 20))
        addAdsVC.title = "Add Your Ad".localize
        categoryVC.tabBarItem.selectedImage = UIImage(named: "CategoryButtonIcon")?.withTintColor(UIColor(named: "#0EBFB1") ?? .yellow, renderingMode: .alwaysOriginal).resized(to: CGSize(width: 25, height: 25))
        categoryVC.tabBarItem.image = UIImage(named: "CategoryIcon 1")?.withTintColor(.gray.withAlphaComponent(0.7), renderingMode: .alwaysOriginal).resized(to: CGSize(width: 20, height: 20))
        categoryVC.title = "Categories".localize
        menuVC.tabBarItem.selectedImage = UIImage(named: "ProfileButtonIcon")?.withTintColor(UIColor(named: "#0EBFB1") ?? .yellow, renderingMode: .alwaysOriginal).resized(to: CGSize(width: 25, height: 25))
        menuVC.tabBarItem.image = UIImage(named: "userProfile")?.withTintColor(.gray.withAlphaComponent(0.7), renderingMode: .alwaysOriginal).resized(to: CGSize(width: 20, height: 20))
        menuVC.title = "Profile".localize
        
        tabBar.tintColor = UIColor(named: "#0EBFB1") ?? .yellow
        viewControllers = [homeVC,categoryVC,addAdsVC,storesVC,menuVC]
    }
    

    
    
    private func createCenterButton() {
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        centerButton.backgroundColor = UIColor(named:"#0EBFB1")
        centerButton.setBackgroundImage(UIImage(named: "AddAdsIconMain"), for: .normal)
        centerButton.setBackgroundImage(UIImage(named: "AddAdsIconMain"), for: .highlighted)
        centerButton.layer.cornerRadius = centerButton.frame.width / 2
        centerButton.addTarget(self, action: #selector(btnTouched), for: .touchUpInside)
        
        view.addSubview(centerButton)
        
        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            centerButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: -25),
            centerButton.widthAnchor.constraint(equalToConstant: 65),
            centerButton.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        centerButton.layer.cornerRadius = 32.5
        centerButton.clipsToBounds = true
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        simpleAnimmationWhenSelectItem(item)
    }
    
    
    //MARK: - Methods
    
    private func setuptabBarAppearance(){
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
            //            tabBar.layer.masksToBounds = true
            //            tabBar.layer.cornerRadius = tabBar.frame.height / 1.7
            //            tabBar.tintColor = .white
            //            tabBar.unselectedItemTintColor = .gray
            //            tabBar.isTranslucent = false
            //            tabBar.layer.borderWidth = 0.8
            //            tabBar.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
            //            tabBar.layer.shadowColor = UIColor.white.withAlphaComponent(0.7).cgColor
            //            tabBar.layer.shadowOffset = CGSize(width: 2, height: 2)
            //            tabBar.layer.shadowOpacity = 0.3
        }
        
    }
    
    private  func simpleAnimmationWhenSelectItem(_ item:UITabBarItem){
        guard let barItemView = item.value(forKey: "view") as? UIView else {return}
        
        let timeInterval:TimeInterval = 0.4
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 1.4, y: 1.4)
        }
        
        propertyAnimator.addAnimations({ barItemView.transform = .identity}, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
    
    @objc func btnTouched(){
        print("btnTouched")
    }
}


