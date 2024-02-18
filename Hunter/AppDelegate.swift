//
//  AppDelegate.swift
//  Bazar
//
//  Created by Amal Elgalant on 12/04/2023.
//

import UIKit
import MOLH
import FirebaseMessaging
import Firebase
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import CircleMenu
import MFSDK
import FirebaseDynamicLinks



@main
class AppDelegate: UIResponder, UIApplicationDelegate,MOLHResetable {
    
    static var currentUser = User()
    static var unVerifiedUserUser = User()
    static var sharedSettings = SettingObject()
    static var currentCountry = Country(nameAr: "الكويت", nameEn: "Kuwait", id: 6,code: "965",currencyAr: "د.ك",currencyEn: "K.D")
//    static var currentCountryId = Constants.countryId

    static var sharedCountry = Country()
   
    static var defaults:UserDefaults = UserDefaults.standard
    static var playerId = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


        let myFatoorahToken = "q3Tkag00mVnNqC2npuUWFzRkZQD5T2tOjSkacpIGLxFLZYFkRDNLrjNMhuGF6Ke7aczsf0ZtuJe3-NdCkHHtnIJDX_1JfidHzf4EqWJABO9JQZ3gN2NZne00JZwSMCQLwO-hAGuJ9huUMNrLtTip5GpFfxc3M2rNupLWAk-wlF5ZC6dyiuLlZc3JVmB4UJ0LJLwFZmZ4clghPmfc_KuEhK_gG5G7nWbB3kVKDDD8T-ktwOH0VUVovVVryGlGPTCAylwF6QHy1XpP-IQSas14LCYonTSDfyILd15fed2cuEWp-dvWZYXEXpoEOAEp3q0ma6KGdnXVH8yf9Wgl2KVNtwUIkelBNgVnIjI_23SU06TgepUq-pPmku9ShkpjDy2OdTF86Isw0oZasHmmUlMjgrTAb9vZWGSFHH4H56YpQ_LEHAxip3Wam3EQ6fevsJUQk2SlHPxFUwUkXPV6hM1Cu45ZX3InxlRadJrXFRcBv67GN7TTnSzlO1BNQn3bhS76YHq4YWJceBCBM2TD5_m5dGO69PalmfcfNKzY8knto-C3iS3tClUfKvALEg6we0VSKlHbh3NIMT4LbD9EzZVNgPCnljoqA5VcHB8O1aiAIfh_eE0RFlYli3NrIVDf7wJTifSmcBUiy8qZ1ZBpyqQCNC0_55-C4UYvj6SMzfvNEAgZa4vG3xHx7RaGNoW3LZB5dVCHT_DqGsJeB9jEeS5AzIxHGL5nGvLNXgUE-V1ptHldBUZ8"
        
        
//        let myFatoorahTestToken = "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL"
        
        MFSettings.shared.configure(token: myFatoorahToken, country: .kuwait, environment: .live)
        // you can change color and title of navigation bar
        if let color = UIColor(named: "#0093F5") {
            let them = MFTheme(navigationTintColor: .white, navigationBarTintColor:color , navigationTitle: "Payment".localize, cancelButtonTitle: "Cancel".localize)
            MFSettings.shared.setTheme(theme: them)
        }
     
        UIFont.overrideInitialize()

        for family in UIFont.familyNames {
            print("\(family)")

            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
        AppDelegate.defaults.removeObject(forKey: "postSessionData")
//        IQKeyboardManager.shared.disabledToolbarClasses = [ChatVC.self]
        IQKeyboardManager.shared.enable = true
        print(AppDelegate.defaults.integer(forKey: "userId"))
//        MOLH.setLanguageTo( "ar")
        MOLH.shared.activate(true)
        reset()
        GMSServices.provideAPIKey(Constants.API_KEY)
        GMSPlacesClient.provideAPIKey(Constants.API_KEY)
        
        let newLanguage = MOLHLanguage.currentAppleLanguage()
        print(newLanguage)
        UserDefaults.standard.set(newLanguage, forKey: "AppLanguage")
      
        
        if AppDelegate.defaults.string(forKey: "token") != nil &&
            
            AppDelegate.defaults.integer(forKey: "userId") != 0{
            AppDelegate.currentUser.toke = AppDelegate.defaults.string(forKey: "token")
            AppDelegate.currentUser.id = AppDelegate.defaults.integer(forKey: "userId")
            ProfileController.shared.getProfile(completion: { [weak self] user,msg in
                guard let self else {return}
                    self.checkNotificationToken()
                AppDelegate.currentCountry = Country(nameAr: AppDelegate.currentUser.countriesNameAr ?? "الكويت", nameEn: AppDelegate.currentUser.countriesNameEn ?? "Kuwait", id: AppDelegate.currentUser.countryId ?? Constants.countryId)
                Constants.headerProd =  ["Authorization":"Bearer \(AppDelegate.currentUser.toke ?? "")"]
                getSettings(countryId: user?.countryId ?? 0)
                
            }, user: AppDelegate.currentUser)
        }else{
            checkNotificationToken()
        }
        getCounties()
        getCities()
        
        
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        //MARK: DEEPLINK HANDLING
        
        if let url = launchOptions?[.url] as? URL {
            // TODO: handle URL from here
            // Example: URL - bazaar://profile/123
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true)else{return (URL(string: "") != nil)}
            // pathComponents = ["", "profile", "123"]
            
//            let pathComponents = components.path.components(separatedBy: "/")
            let pathComponents = extractCustomComponents(from: url)
            print(components, "   " , pathComponents)

            
            // Handle different paths
            if pathComponents.count >= 2 && pathComponents[0] == "profile" {
                let profileId = pathComponents[1]
                redirectToProfile(withId: profileId)
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let paymentId = url[MFConstants.paymentId] {
            NotificationCenter.default.post(name: .applePayCheck, object: paymentId)
        }
        
            guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                let path = components.path else {
                    return false
            }

            // Example: URL - bluezonebazaar://profile/123
            let pathComponents = path.components(separatedBy: "/")
            // pathComponents = ["", "profile", "123"]
            
            // Handle different paths
            if pathComponents.count > 2 && pathComponents[1] == "profile" {
                let profileId = pathComponents[2]
                // Redirect to profile with profileId
               // redirectToProfile(withId: profileId)
            }
        

        print("Opened URL: \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
               // Handle the dynamic link. For example, navigate to appropriate content
               if let dynamicLinkURL = dynamicLink.url {
                   print("Open -> \(dynamicLinkURL)")
                   // Handle the deep link. For example, show the linked content,
                   // apply a promotional offer, etc.
               }
               return true
           }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL else {
            return false
        }

        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
            // Handle the dynamic link. For example, navigate to appropriate content
            if let dynamicLinkURL = dynamicLink?.url {
                print(dynamicLinkURL)
                // Handle the deep link. For example, show the linked content,
                // apply a promotional offer, etc.
            }
        }

        return handled
    }

   

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // refreshedToken is variable. I use it in viewcontroller.
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let token = token {
                print("Remote instance ID token: \(token)")
                AppDelegate.playerId = token
            }
        }
    }
    
    private func getSettings(countryId:Int){
        //Get Settings API
        PayingController.shared.getSettings(completion: {[weak self] settings, check, message in
            guard let self else {return}
            if check == 0 {
                if let settings = settings {
                    print(settings)
                    AppDelegate.sharedSettings = settings
                }
            }else {
                print(message)
            }
        }, countryId:AppDelegate.currentUser.countryId.safeValue)
    }
    
    func checkNotificationToken(){
        if AppDelegate.defaults.string(forKey: "playerId") != nil{
            
            AppDelegate.playerId = AppDelegate.defaults.string(forKey: "playerId") ?? ""
            NotificationsController.shared.saveToken(token: AppDelegate.playerId)
            
        }
    }
    
    func getCounties(){
        CountryController.shared.getCountries(completion: {
            countries, check,msg in
            AppDelegate.sharedCountry = countries.first { $0.id == AppDelegate.currentCountry.id.safeValue } ?? AppDelegate.currentCountry
            print(countries.first { $0.id == AppDelegate.currentCountry.id.safeValue })
            Constants.COUNTRIES = countries
        })
    }
    func getCities(){
        CountryController.shared.getCities(completion: {
            countries, check,msg in
            // Use matchedItem here
            Constants.CITIES = countries
        }, countryId: 6)
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    @available(iOS 13.0, *)
    func swichRoot(){
        //Flip Animation before changing rootView
        animateView()
        
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
        
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.window!.rootViewController = nav
        }
        
    }
    @available(iOS 13.0, *)
    func animateView() {
        var transition = UIView.AnimationOptions.transitionFlipFromRight
        if !MOLHLanguage.isRTLLanguage() {
            transition = .transitionFlipFromLeft
        }
        animateView(transition: transition)
    }
    
    @available(iOS 13.0, *)
    func animateView(transition: UIView.AnimationOptions) {
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate {
            UIView.transition(with: (((delegate as? SceneDelegate)!.window)!), duration: 0.5, options: transition, animations: {}) { (f) in
            }
        }
    }
    func reset() {
        let newLanguage = MOLHLanguage.currentAppleLanguage()
        print(newLanguage)
        UserDefaults.standard.set(newLanguage, forKey: "AppLanguage")

        if let window = UIApplication.shared.windows.first {
            let sb = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil)
               window.rootViewController = sb.instantiateViewController(withIdentifier: "TabBarVC")
               window.makeKeyAndVisible()
           }
//        let rootViewController: UIWindow = ((UIApplication.shared.delegate?.window)!)!
//                let story = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil)
//                rootViewController.rootViewController = story.instantiateViewController(withIdentifier: "homeT")
        
//        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
//        let stry = UIStoryboard(name: "Main", bundle: nil)
//        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "homeT")
    }
    
    
    private func getnotifictionCounts(){
        NotificationsController.shared.getNotificationsCount(completion: {
            count, check, msg in
            
            if check == 1{
                StaticFunctions.createErrorAlert(msg: msg)
            }else{
                Constants.notificationsCount = count?.data?.count ?? 0
                
            }
        })
    }
    
}


extension AppDelegate : UNUserNotificationCenterDelegate{
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        let title = notification.request.content.title
        print(userInfo)
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // ...
        
        // Print full message.
        
        //   print("notification Title ",title)
        
        // Change this to your preferred presentation option
        return [[.banner, .sound , .badge]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        if UIApplication.shared.applicationState == .active {
            
            //              if let aps = userInfo as? NSDictionary {
            //                            print(aps)
            //                  if let apsDidt = aps["a_data"] as? NSDictionary{
            //                     print(apsDidt)
            //
            //                      if let nftype = apsDidt["ntype"]  as? String {
            //                          print(nftype)
            //                      }
            ////                      if let oid = (apsDidt as! NSDictionary).value(forKey: "oid") as? String {
            ////                          print(oid)
            ////                      }
            ////                          if let notification_type = alertDict.value(forKey: "name") as? String {
            ////
            ////                          }
            //
            //                      }}}
            print(userInfo["fid"] as? Int)
            
            if let ntype = userInfo["ntype"] as? String {
                print(ntype)
            }
            // ...
            
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            
            // Print full message.
            
        }
        
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["gcm.Message_ID"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("user Data ",userInfo)
        
        return UIBackgroundFetchResult.newData
    }
    
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
}


extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        
        
        
        AppDelegate.playerId = fcmToken ?? ""
        NotificationsController.shared.saveToken( token: fcmToken ?? "")

        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
    }
    
    
    
    //MARK: DEEPLINK
    func extractCustomComponents(from url: URL) -> [String] {
        let urlString = url.absoluteString

        guard let range = urlString.range(of: "://") else {
            return []
        }
        
        let parametersString = urlString[range.upperBound...]
        let components = parametersString.components(separatedBy: "/")
        
        return components.filter { !$0.isEmpty }
    }
    
    func redirectToProfile(withId id: String) {
        // Ensure you have access to a root view controller or navigation controller
//        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let tabBarController = scene.windows.first?.rootViewController as? UITabBarController,
//              let navigationController = tabBarController.selectedViewController as? UINavigationController else {
//            return
//        }
        guard let rootViewController = getRootViewController() else {
                return
            }
        // Instantiate the profile view controller
        let profileVC = StoreProfileVC.instantiate()
        profileVC.otherUserId = Int(id) ?? 0

        // Perform the navigation
            if let navigationController = rootViewController as? UINavigationController {
                navigationController.pushViewController(profileVC, animated: true)
            } else if let tabBarController = rootViewController as? UITabBarController,
                      let navigationController = tabBarController.selectedViewController as? UINavigationController {
                navigationController.pushViewController(profileVC, animated: true)
            } else {
                // Adjust this part as per your app's view hierarchy
                rootViewController.present(profileVC, animated: true)
            }
    }
    func getRootViewController() -> UIViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
        
        
        return nav
    }
    
}
