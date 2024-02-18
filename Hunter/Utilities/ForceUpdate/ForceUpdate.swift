//
//  ForceUpdate.swift
//  NewBazar
//
//  Created by iOSAYed on 14/01/2024.
//

import Foundation

final class ForceUpdateNative{
    
    
   static let shared = ForceUpdateNative()
    
    let appleId = "1511596620"
    
    func checkForUpdates(completion: @escaping (String?) -> Void) {
        
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleId)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {
                    
                    completion(appStoreVersion)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    
    func isForceUpdate(currentVersion:String , appStoreVersion:String)  {
        if currentVersion != appStoreVersion {
//            DispatchQueue.main.async {
                // Show alert to update app
            
            DispatchQueue.main.async {
                
            }
        }
    }
        
//        func showUpdateAlert() {
//            let alertController = UIAlertController(title: "New Version Available",
//                                                    message: "A new version of the app is available. Please update to continue using.",
//                                                    preferredStyle: .alert)
//
//            let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
//                if let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID_HERE"),
//                   UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            }
//
//            alertController.addAction(updateAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
    }