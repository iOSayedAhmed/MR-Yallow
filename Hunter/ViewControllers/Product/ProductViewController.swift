//
//  ProductViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 05/05/2023.
//

import UIKit
//import ImageSlideshow
import MOLH
import MediaSlideshow
import CircleMenu
import FirebaseDynamicLinks
import FirebaseAuth
import AVFoundation

class ProductViewController: UIViewController {
    
    static func instantiate()-> ProductViewController{
        let productVC = UIStoryboard(name: "Product", bundle: nil).instantiateViewController(withIdentifier: "product_details") as! ProductViewController
        
        return productVC
    }
    
    @IBOutlet weak var callLbl: UILabel!
    @IBOutlet weak var chatBtn: UIView!
    @IBOutlet weak var whatsappBtn: UIView!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var reportView: UIStackView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentsCountLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var selLbl: UILabel!
    @IBOutlet weak var sellImage: UIView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var nameBtn: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var imageSlider: MediaSlideshow!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userVerifieddImage: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var contactWaysButton: CircleMenu!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var circleMenu = CircleMenu(frame: .zero, normalIcon: "", selectedIcon: "")

    let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "full_screen") as! FullScreenViewController
    var product = Product()
    var images = [ProductImage]()
    var sliderImages = [String]()
    var comments = [Comment]()
   
    var dataSource = ImageAndVideoSlideshowDataSource(sources:[
        
    ])
    let avSource = AVSource(url: URL(string: "") ?? URL(fileURLWithPath: ""), autoplay: true)
    
    var isFav = false
    
    var tableHeight: CGFloat {
        tableView.layoutIfNeeded()
        
        return tableView.contentSize.height
    }
    private var fanMenuView: FanMenuView!
    private var isFollow = false
 
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationBar = navigationController?.navigationBar {
                    navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Change the color to your desired color
                }
        self.navigationController?.navigationBar.isHidden = true
        setupSlider()
        userVerifieddImage.isHidden = true
        sellImage.isHidden = true
        // Do any additional setup after loading the view.
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(_:)), name: NSNotification.Name(rawValue: "updateData"), object: nil)
        followButton.isHidden = true
        circleMenu.isHidden = true
        
        setupCircleMenu()
        getData()
        imageSlider.contentScaleMode = .scaleAspectFill
        
    }
    

    
    func setupCircleMenu(){
        if MOLHLanguage.isArabic() {
            circleMenu  = CircleMenu(frame: CGRect(x:view.frame.width - 100, y: view.frame.height - 200, width: 50, height: 50),
                            normalIcon:"phone_icon",
                            selectedIcon:"close_icon",
                            buttonsCount: 3,
                                     duration: 1.5,
                            distance: 100,isArabic: true)
        }else {
            circleMenu  = CircleMenu(frame: CGRect(x:20, y: view.frame.height - 200, width: 50, height: 50),
                            normalIcon:"phone_icon",
                            selectedIcon:"close_icon",
                            buttonsCount: 3,
                                     duration: 1.5,
                            distance: 100,isArabic: false)
        }
        circleMenu.delegate = self
        view.addSubview(circleMenu)
        circleMenu.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    @objc func updateData(_ notification: NSNotification) {
//        comments.removeAll()
        getData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        getData()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
//        self.avSource.player.isMuted = true
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
       var index = imageSlider.currentPage
        if !sliderImages.isEmpty {
            if (sliderImages[index].contains(".mp4") || sliderImages[index].contains(".mov")){
                dataSource.sources.remove(at: index)
                dataSource.sources.insert( .av(AVSource(url: URL(string:sliderImages[index])!, autoplay: false)), at: index)
                    
                

                imageSlider.reloadData()

            }
        }
        
//        if let avplayer = sliderImages[index]{
//            print("video")
//        }
    }
    
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = false
//        self.tabBarController?.tabBar.isHidden = false
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//    }
    
//    @IBAction func sliderClicked(_ sender: Any) {
////        full_screen
//        let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "full_screen") as! FullScreenViewController
//        vc.dataSource = dataSource
////      let source = dataSource.sources[imageSlider.currentPage] as! AVSource
////        source.pla
////            .source.player.pause()
//        self.present(vc, animated: false, completion: nil)       
//    }
    @IBAction func userClickedAction(_ sender: Any) {
        if StaticFunctions.isLogin() {
            if product.isStore ?? false {
                let vc = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "StoreProfileVC") as! StoreProfileVC
                vc.otherUserId = product.userId ?? 0
                vc.navigationController?.navigationBar.isHidden = true
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                if AppDelegate.currentUser.id ?? 0 == product.userId ?? 0 {
                    let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PROFILE_VCID) as! ProfileVC
                    vc.navigationController?.navigationBar.isHidden = true
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
                    vc.OtherUserId = product.userId ?? 0
                    vc.navigationController?.navigationBar.isHidden = true
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
           
            
        }else {
            
            StaticFunctions.createErrorAlert(msg: "you have to login first".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
        }
        

    }
    @IBAction func backAction(_ sender: Any) {
//        dismissDetail()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapFollowButton(_ sender: UIButton) {
        
        if StaticFunctions.isLogin() {
            
                ProfileController.shared.followUser(completion: {[weak self]
                    check, msg in
                    guard let self else {return}
                    if check == 0{
                        isFollow.toggle()
                        isFollow ? followButton.setTitle("unfollow".localize, for: .normal) : followButton.setTitle("follow".localize, for: .normal)
                        
                        
                    }else{
                        StaticFunctions.createErrorAlert(msg: msg)
                    }
                }, OtherUserId: self.product.userId ?? 0)
            
        }else{
            StaticFunctions.createErrorAlert(msg: "Please Login First".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
            
        }

    }
    
    
    
    @IBAction func flageActiion(_ sender: Any) {
        let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: FLAG_VCID) as! ReportViewController
        vc.id = self.product.id ?? 0
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func addToFavAction(_ sender: Any) {
        if StaticFunctions.isLogin(){
            ProductController.shared.likeAd(completion: {
                check, msg in
                if check == 0{
                    self.product.fav = self.product.fav == 1 ? 0 : 1
                    if self.product.fav == 1 {
                        self.favBtn.setImage(UIImage(named: "heartFill"), for: .normal)
                        self.isFav = true
                    }else{
                        self.isFav = false
                        self.favBtn.setImage(UIImage(named: ""), for: .normal)
                        
                    }
                    
                }else{
                    StaticFunctions.createErrorAlert(msg: msg)
                    
                }
            }, id:  self.product.id ?? 0)
        }else{
            StaticFunctions.createErrorAlert(msg: "you have to login first".localize)
            basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
        }
        
    }
    @IBAction func shareAction(_ sender: Any) {
//        let textToShare = ["\(product.name ?? "")" + "\ndownload Bazar app from apple store" + " https://apps.apple.com/us/app/Bazar/id1589937521" ]
//        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
//        self.present(activityViewController, animated: true, completion: nil)
        
        shareStoreProfile()
    }
    @IBAction func callAction(_ sender: Any) {
        let callPhone = "+\(product.phone ?? "")"
        guard let number = URL(string: "telprompt://" + callPhone) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
        print(callPhone)
        
    }
    @IBAction func whatsappAction(_ sender: Any) {
        let txt1 = "I want to talk to you about your advertisement".localize
        let txt2 = "on Bazar app".localize
        var link = "\(txt1) \(product.name ?? "")\n\(txt2)"
        let escapedString = link.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url  = URL(string: "whatsapp://send?phone=\(product.whatsappPhone ?? "")&text=\(escapedString!)")
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
       
        
        
        
    }
    

    
    
    private func shareStoreProfile(){
        guard let link = URL(string: "https://www.bazar-kw.com/prod/?ad_id=" + "\(product.id ?? 0)") else { return }
                let dynamicLinksDomainURIPrefix = "https://bazaaarad.page.link"
                guard let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) else { return }
                        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.bazaaar.app")
        // Set social meta tag parameters
        let socialTags = DynamicLinkSocialMetaTagParameters()
        socialTags.imageURL = URL(string: Constants.IMAGE_URL+(product.mainImage ?? ""))
        socialTags.title = product.name.safeValue
        socialTags.descriptionText = product.description.safeValue
        linkBuilder.socialMetaTagParameters = socialTags
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.bazar-kw.com/prod/?ad_id=" + "\(product.id ?? 0)")
        actionCodeSettings.dynamicLinkDomain = "https://bazaaarad.page.link"
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
                
                guard let longDynamicLink = linkBuilder.url else { return }
                print(longDynamicLink)
                linkBuilder.shorten() { url, warnings, error in
                    guard let url = url, error == nil else {
                        
                        return }
                    print("The short URL is: \(url)")
                    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                   
                    self.present(activityViewController, animated: true, completion: nil)
                }
    }
    
    
    
    
    
    func whatsappShareText(_ num: String = "",_ link: String = "")
    {
        let escapedString = link.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url  = URL(string: "whatsapp://send?phone=\(num)&text=\(escapedString!)")
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func chatActoin(_ sender: Any) {
        if product.hasChat == "off" {
            StaticFunctions.createErrorAlert(msg: "The user has disabled chat for this ad".localize)
        }else {
            ChatController.shared.create_room(completion: {
                id,check, msg in
                if check == 0{
                    if id != -1{
                        receiver.room_id = "\(id)"
                    }
                    if AppDelegate.currentUser.id ?? 0 == self.product.userId ?? 0 {
                        StaticFunctions.createErrorAlert(msg: "You Can't chat with yourself".localize)
                    }else {
                        Constants.otherUserPic = self.product.userPic ?? ""
                        Constants.otherUserIsStore = self.product.isStore ?? false
                        Constants.otherUserName = self.product.userName ?? ""
                        print(self.product.userName ?? "")
                        self.basicNavigation(storyName: "Chat", segueId: "ChatVC")
                    }
                }else{
                    StaticFunctions.createErrorAlert(msg: msg)
                }
                
            }, id: product.userId ?? 0)
        }
        
    }
    @IBAction func addComment(_ sender: Any) {
        if StaticFunctions.isLogin(){
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COMMENT_VCID) as! CommentViewController
            vc.id = self.product.id ?? 0
            self.present(vc, animated: false, completion: nil)
        }else{
            StaticFunctions.createErrorAlert(msg: "you have to login first".localize)
            basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
        }
        
      
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ProductViewController{
    func getData(){
        ProductController.shared.getProducts(completion: { [weak self]
            product, check, msg in
            guard let self else {return}
            if check == 0{
                print(product.images.count)
                self.getUserProfile()
                self.product = product.data
                self.images = product.images
                self.comments = product.comments
                
                self.tableView.reloadData()
                print( self.tableViewHeight.constant)
                self.tableViewHeight.constant = self.tableHeight
                //                self.tableView.layoutIfNeeded()
                self.updateViewConstraints()
                
                print( self.tableViewHeight.constant)
                
                self.setData()
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
                self.navigationController?.popViewController(animated: true)
            }
            
        }, id: product.id ?? 0)
    }
    
    
    private func getUserProfile(){
        ProfileController.shared.getOtherProfile(completion: {[weak self] userProfile, msg in
            guard let self = self else {return}
            if let userProfile = userProfile {
                print("======= profile Data ======== ")
                if userProfile.isFollow == 1 {
                    isFollow = true
                }else {
                    isFollow = false
                }
                userProfile.isFollow == 1 ? followButton.setTitle("unfollow".localize, for: .normal) : followButton.setTitle("follow".localize, for: .normal)
            }
        }, userId: product.userId ?? 0)
    }
    
    func setData(){
    
        circleMenu.isHidden =  product.userId == AppDelegate.currentUser.id
        followButton.isHidden = product.userId == AppDelegate.currentUser.id
        
         var mainImage = ""
        if product.mainImage != ""  {
            mainImage = product.mainImage ?? ""
        }else{
            mainImage = product.image ?? ""
        }
            
            if mainImage != ""{
                if mainImage.contains(".mp4") || mainImage.contains(".mov"){
                    images.insert(ProductImage(id: -1, prodID: 0, pimage: mainImage, imageType: "VIDEO", createdAt: "", updatedAt: "", image: Constants.IMAGE_URL + mainImage), at: 0)
                }else{
                    images.insert(ProductImage(id: -1, prodID: 0, pimage:  mainImage, imageType: "IMAGE", createdAt: "", updatedAt: "", image: Constants.IMAGE_URL + mainImage), at: 0)
                }
                
            }
        
         dataSource = ImageAndVideoSlideshowDataSource(sources:[])
        
        for img in images{
            print("imgs count ",images.count)
            if let image = img.pimage  {
                print(image)
                guard let media_type = img.imageType  else {return}
                // prodC.sources_urls.append("\(user.newUrl)\(timg)")
                sliderImages.append(Constants.IMAGE_URL + image)
                if media_type == "VIDEO"{
                    let asset = AVAsset(url: URL(string:Constants.IMAGE_URL + image)!)
                               let orientationInfo = videoOrientation(from: asset)

                               switch orientationInfo.orientation {
                               case .up:
                                   // Apply no transformation
                                   print("UP")
                                   break
                               case .left:
                                   // Apply left rotation
                                   print("LEFT")
                                   break
                               case .right:
                                   // Apply right rotation
                                   print("RIGHT")
                                   break
                               case .down:
                                   // Apply upside-down rotation
                                   print("DOWN")
                                   break
                               default:
                                   break
                               }
                    
                    if image != "" {
                        print(image)
                        dataSource.sources.append(
                            
                            .av(AVSource(url: URL(string:Constants.IMAGE_URL + image)!, autoplay: true)))
                        
                        
                    }
                }else{
                    if image != "" {
                        
                        dataSource.sources.append(
                            .image(AlamofireSource(urlString:Constants.IMAGE_URL + image )!))
                        print(dataSource.sources)
                    }
                    
                }
            }}
        
        imageSlider.dataSource = dataSource
        print(dataSource.sources.count)
        imageSlider.reloadData()
//        self.imageSlider.setCurrentPage(images.count - 1, animated: true)

        self.nameBtn.text = product.name
        if let createDate = product.createdAt{
//            if createDate.count > 11 {
//                print(createDate)
//                print(diffDates(GetDateFromString(createDate)).replace("-", ""))
//                self.dateLbl.text =   diffDates(GetDateFromString(createDate)).replace("-", "")
//                
//            }
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            let pastDate = dateFormatter.date(from:createDate ) ?? Date()
            
            dateLbl.text = pastDate.timeAgoDisplay()
        }
        commentsCountLbl.text = "(\(product.comments.safeValue))"
        
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            currencyLbl.text = product.currencyEn
            locationLbl.text = product.cityNameEn
            categoryLabel.text = product.mainCatNameEn.safeValue + " > " + product.subCatNameEn.safeValue
            
        }else{
            currencyLbl.text = product.currencyAr
            locationLbl.text = product.cityNameAr
            categoryLabel.text = product.mainCatNameAr.safeValue + " < " + product.subCatNameAr.safeValue
            
        }
//        self.viewsLabel.text = "\(product.views ?? 0)"    
        self.descriptionLbl.numberOfLines = 0
        self.descriptionLbl.text = product.description
        self.descriptionLbl.sizeToFit()
        view.layoutIfNeeded()
        if product.userVerified == 1{
            userVerifieddImage.isHidden = false
        }else{
            userVerifieddImage.isHidden = true
        }
        
        if let tajeerOrSell = product.adType  {
            sellImage.isHidden = false
            if( tajeerOrSell == "rent"){
                selLbl.text = "rent".localize
                selLbl.textColor = .white
                sellImage.layer.borderWidth = 1.0
                sellImage.layer.borderColor = UIColor(named: "#213970")?.cgColor
                sellImage.clipsToBounds = true
                sellImage.backgroundColor = UIColor(named: "#213970")
            }else if ( tajeerOrSell == "sell") {
                selLbl.text = "sell".localize
                sellImage.layer.borderWidth = 1.0
                sellImage.layer.borderColor = UIColor(named: "#0093F5")?.cgColor
                sellImage.clipsToBounds = true
                selLbl.textColor = .white
                sellImage.backgroundColor = UIColor(named: "#0093F5")
            } else if ( tajeerOrSell == "donation") {
                selLbl.text = "DONATION".localize
                sellImage.layer.borderWidth = 1.0
                sellImage.layer.borderColor = UIColor(named: "DonationColor")?.cgColor
                sellImage.clipsToBounds = true
                selLbl.textColor = .white
                sellImage.backgroundColor = UIColor(named: "DonationColor")
            }else if ( tajeerOrSell == "buying") {
                selLbl.text = "BUYING".localize
                sellImage.layer.borderWidth = 1.0
                sellImage.layer.borderColor = UIColor(named: "buyingColor")?.cgColor
                sellImage.clipsToBounds = true
                selLbl.textColor = .white
                sellImage.backgroundColor = UIColor(named: "buyingColor")
            }
        }
        if product.fav == 1 {
            self.favBtn.setImage(UIImage(named: "heartFill"), for: .normal)
            isFav = true
        }else{
            self.isFav = false
            self.favBtn.setImage(UIImage(named: ""), for: .normal)
            
        }
        
        if product.isStore ?? false {
            userNameLbl.text = "Store".localize + " " + (product.userName ?? "") + " " + (product.userLastName ?? "")
        }else{
            userNameLbl.text = (product.userName ?? "") + " " + (product.userLastName ?? "")
        }
        
        print(product.userPic ?? "")
        self.userImageView.setImageWithLoading(url: product.userPic ?? "",placeholder: "logo_photo")
        
        
        if   product.userVerified == 1 {
            self.userVerifieddImage.isHidden = false
        }else{
            self.userVerifieddImage.isHidden = true
        }
        if( product.hasPhone == "on"){
            callBtn.isHidden = false
            callLbl.isHidden = true
        }else{
            callBtn.isHidden = true
            callLbl.isHidden = false
        }
        
        if( product.hasWhatsapp == "on"){
            whatsappBtn.isHidden = false
        }else{
            whatsappBtn.isHidden = true
            
        }
        
        if(product.hasChat == "on") || product.hasPhone != "on"{
            if AppDelegate.currentUser.id != (product.userId ?? 0){
                chatBtn.isHidden = false
            }else{
                chatBtn.isHidden = true
            }
            
        }else{
            chatBtn.isHidden = true
        }
        
        self.viewsLabel.text = "\(product.views ?? 0) " + "views".localize
        self.priceLbl.text = "\(product.price ?? 0)"
        
        
    }
    func setupSlider(){
        imageSlider.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
        imageSlider.contentScaleMode = .scaleToFill
//        imageSlider.slideshowInterval = 5
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlider.addGestureRecognizer(gestureRecognizer)
        imageSlider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customBottom(padding: 40))
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor(named: "#0093F5")
        pageIndicator.pageIndicatorTintColor = UIColor.white
        imageSlider.pageIndicator = pageIndicator
    }
    @objc func didTap() {
        let fullScreenController = imageSlider.presentFullScreenController(from: self)
           // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
           fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
}
extension ProductViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductCommentTableViewCell
        cell.setData(comment: comments[indexPath.row])
        
        cell.replyBtclosure = {
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: REPLY_VCID) as! ReplyViewController
            vc.id = self.comments[indexPath.row].id ?? 0
            self.present(vc, animated: false, completion: nil)
            
        }
        cell.showUserProfileBtclosure = {
            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
            
            vc.OtherUserId = self.comments[indexPath.row].userId ?? 0
            vc.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.flagBtclosure = {
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: REPORT_COMMENT_VCID) as! ReportCommentViewController
            vc.id = self.comments[indexPath.row].id ?? 0
            self.present(vc, animated: false, completion: nil)
            
        }
        cell.likeBtclosure  = {
            ProductController.shared.likeComment(completion: {
                check, msg in
                if check == 0{
                    self.comments[indexPath.row].isLike =  self.comments[indexPath.row].isLike == 1 ? 0 : 1
                    if self.comments[indexPath.row].isLike == 1{
                        self.comments[indexPath.row].countLike! += 1
                        cell.img_liked.image = UIImage(named: "ic_heartRedFill")
                    }else{
                        self.comments[indexPath.row].countLike! += -1
                        cell.img_liked.image = UIImage(named: "heartgrey")
                    }
                    cell.likes.text = "\(self.comments[indexPath.row].countLike ?? 0)"

                }else{
                    StaticFunctions.createErrorAlert(msg: msg)

                }
            }, id:  self.comments[indexPath.row].id ?? 0)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COMMENT_REPLY_VCID) as! CommentRepliesViewController
        vc.data.comment = self.comments[indexPath.row]
//        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ProductViewController : CircleMenuDelegate {
    // configure buttons
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int){
        if atIndex == 0 {
            button.backgroundColor = .green
            button.setImage(UIImage(named: "callNewIcon"), for: .normal)
        }else if atIndex == 1 {
            
            button.setImage(UIImage(named: "ChatNewIcon"), for: .normal)
        }else if atIndex == 2 {
            button.backgroundColor = .green.withAlphaComponent(0.8)
            button.setImage(UIImage(named: "whatsNewIcon"), for: .normal)
        }
    }
    
    // call before animation
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        
    }

    // call after animation
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int){
        

        if atIndex == 0 {
            let callPhone = "+\(product.phone ?? "")"
                        guard let number = URL(string: "telprompt://" + callPhone) else { return }
                        UIApplication.shared.open(number, options: [:], completionHandler: nil)
                        print(callPhone)
        }else if atIndex == 1 {
            if product.hasChat == "off" {
                StaticFunctions.createErrorAlert(msg: "The user has disabled chat for this ad".localize)
            }else {
                ChatController.shared.create_room(completion: {
                    id,check, msg in
                    if check == 0{
                        if id != -1{
                            receiver.room_id = "\(id)"
                        }
                        if AppDelegate.currentUser.id ?? 0 == self.product.userId ?? 0 {
                            StaticFunctions.createErrorAlert(msg: "You Can't chat with yourself".localize)
                        }else {
                            Constants.otherUserPic = self.product.userPic ?? ""
                            Constants.otherUserIsStore = self.product.isStore ?? false
                            Constants.otherUserName = self.product.userName ?? ""
                            print(self.product.userName ?? "")
                            self.basicNavigation(storyName: "Chat", segueId: "ChatVC")
                        }
                    }else{
                        StaticFunctions.createErrorAlert(msg: msg)
                    }
                    
                }, id: product.userId ?? 0)
            }
        }else if atIndex == 2 {
                    let txt1 = "I want to talk to you about your advertisement".localize
                    let txt2 = "on Bazar app".localize
                    var link = "\(txt1) \(product.name ?? "")\n\(txt2)"
                    let escapedString = link.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
                    let url  = URL(string: "whatsapp://send?phone=\(product.whatsappPhone ?? "")&text=\(escapedString!)")
                    if UIApplication.shared.canOpenURL(url! as URL){
                        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                    }
        }
    }

    // call upon cancel of the menu - fires immediately on button press
    func menuCollapsed(_ circleMenu: CircleMenu){}

    // call upon opening of the menu - fires immediately on button press
    func menuOpened(_ circleMenu: CircleMenu){
            
    }
}

extension ProductViewController : FanMenuDelegate {
    func didTapButton1() {
        print("Hello Button 1")
    }
}


extension ProductViewController {
    func videoOrientation(from asset: AVAsset) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        guard let track = asset.tracks(withMediaType: AVMediaType.video).first else {
            return (.up, false)
        }

        let size = track.naturalSize
        let transform = track.preferredTransform

        // Check the orientation and return the corresponding values
        if size.width == transform.tx && size.height == transform.ty {
            return (.left, true)
        } else if transform.tx == 0 && transform.ty == 0 {
            return (.right, true)
        } else if transform.tx == 0 && transform.ty == size.width {
            return (.down, false)
        } else {
            return (.up, false)
        }
    }

}
