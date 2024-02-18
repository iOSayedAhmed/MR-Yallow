//
//  ForceUpadeVC.swift
//  NewBazar
//
//  Created by iOSAYed on 14/01/2024.
//

import UIKit

class ForceUpadeVC:BottomPopupViewController {
        
    
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
           
            
        }

  
        
        override func getPopupHeight() -> CGFloat {
            return 750
        }
        
        override func getPopupTopCornerRadius() -> CGFloat {
            return 25
        }
        
        override func getPopupPresentDuration() -> Double {
            0.2
        }
        
        override func getPopupDismissDuration() -> Double {
            0.2
        }
        
        override func shouldPopupDismissInteractivelty() -> Bool {
            false
        }
        
        override func getDimmingViewAlpha() -> CGFloat {
            0.6
        }
    
    private func handleForceUpdate() {
            
        if let url = URL(string: "https://apps.apple.com/eg/app/bazar/id\(Constants.APPLE_ID)"),
           UIApplication.shared.canOpenURL(url){
            print(url)
            
            UIApplication.shared.open(url, options: [:]) { (_) in
            }
        }
        
        }

    
    
    
    @IBAction func didtapUpdateNow(_ sender: UIButton) {
        print("Go to app store")
        dismiss(animated: true) { [weak self] in
            guard let self else {return}
            handleForceUpdate()
        }
        
    }
    
    @IBAction func didtapNotNow(_ sender: UIButton) {
        print("Go to app store")
        dismiss(animated: true) {
            UserDefaults.standard.set(true, forKey: "isUserCanceledForceUpdate")
        }
    }
}
