//
//  AddStoreVC.swift
//  Bazar
//
//  Created by iOSayed on 28/08/2023.
//

import UIKit
import TransitionButton
import MOLH

enum ValidationResult {
    case success
    case failure(String)
}

class CreateStoreVC: UIViewController {
    
    static func instantiate()-> CreateStoreVC{
        let addStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "AddStoreVC") as! CreateStoreVC
        
        return addStoreVC
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var activityTextFiled: UITextField!
    @IBOutlet weak var mobileTextFiled: UITextField!
    @IBOutlet weak var whatsAppNumberTextFiled: UITextField!
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var countryNameButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var aboutCompanyTextField: UITextField!
    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var registerButton: TransitionButton!
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    @IBOutlet weak var contryMobileCode: UILabel!
    
    @IBOutlet weak var regonBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var mainCatBtn: UIButton!
    @IBOutlet weak var subCatBtn: UIButton!
    
    @IBOutlet weak var institutionView: UIView!
    @IBOutlet weak var institutionImage: UIImageView!
    @IBOutlet weak var institutionButton: UIButton!
    @IBOutlet weak var individualView: UIView!
    @IBOutlet weak var individualImage: UIImageView!
    @IBOutlet weak var individualButton: UIButton!
    @IBOutlet weak var uploadLicenseView: UIView!
    @IBOutlet weak var compunyNameLabel: UILabel!
    
    
    // MARK: - Properties
    var isCompany = 0  
    var isStorelogo = false
    var storeLogoImage = UIImage()
    var storeLicenseImage = UIImage()
    var isPasswordHidden = true
    var isAgreeConditions = false
    var coountryVC = CounriesViewController()
    var countryId = AppDelegate.currentCountry.id ?? 6
    var cityId = -1
    var stateId = -1
    var countryName = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
    var countryCode =  AppDelegate.currentCountry.code
    // Main Category DropDwon
    var mainCatID:Int = -1
    var mainCatName:String = ""
    var mainCatsList = [String]()
    var mainCatsIDsList = [Int]()
    
    // Sub Category DropDwon
    var subCatID:Int = -1
    var subCatName:String = ""
    var subCatsList = [String]()
    var subCatsIDsList = [Int]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        configureView()
        getMainCats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
//        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
    }
    
    // MARK: - Methods
    
    private func configureView(){
        self.title = "Add Institution".localize
        self.navigationController?.navigationBar.tintColor = .white
        licenseImageView.isHidden = true
        self.countryNameButton.setTitle(self.countryName, for: .normal)
        setUpInstitutionButton()
    }
    
    private func setUpInstitutionButton(){
        institutionView.borderWidth = 1.2
        institutionView.backgroundColor = UIColor(named: "#0EBFB1")
        institutionView.borderColor = .white
        institutionImage.isHidden = false
        let image = UIImage(systemName: "checkmark.square.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        institutionImage.image = image
        individualView.borderWidth = 0.7
        individualView.backgroundColor = .white
        individualView.borderColor = UIColor(named: "#0EBFB1")
        setImage(to: individualImage, from: "uncheckButtonImage2")
        compunyNameLabel.text = "Company name".localiz()
        uploadLicenseView.isHidden = false
        
    }
    private func setUpIndividualButton(){
        individualView.borderWidth = 1.2
        individualView.backgroundColor = UIColor(named: "#0EBFB1")
        individualView.borderColor = .white
        individualImage.isHidden = false
        let image = UIImage(systemName: "checkmark.square.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        individualImage.image = image
        institutionView.borderWidth = 0.7
        institutionView.backgroundColor = .white
        institutionView.borderColor = UIColor(named: "#0EBFB1")
        setImage(to: institutionImage, from: "uncheckButtonImage2")
        compunyNameLabel.text = "Full name".localiz()
        uploadLicenseView.isHidden = true
    }
    
    
    func validateFieldsAndShowFirstError(validations: [ValidationResult]) -> Bool {
        for validation in validations {
            switch validation {
            case .failure(let message):
                StaticFunctions.createErrorAlert(msg: message)
                return false
            case .success:
                continue
            }
        }
        return true
    }
    
    func validateTextField(_ textField: UITextField, errorMessage: String) -> ValidationResult {
        if let text = textField.text, !text.isEmpty {
            return .success
        } else {
            return .failure(errorMessage)
        }
    }
    
    func validateUIImage(_ image: UIImage, errorMessage: String) -> ValidationResult {
        if  image.size.width == 0 || image.size.height == 0  {
            return .failure(errorMessage)
        } else {
            return .success
        }
    }
    
    
    private func validateAndPrintMessages() -> Bool {
        let validations: [ValidationResult] = [
            validateUIImage(storeLogoImage, errorMessage: "Please Choose Store logo image".localize),
            validateTextField(fullNameTextField, errorMessage: "Please enter your name".localize),
            validateTextField(activityTextFiled, errorMessage: "Please enter your activity".localize),
            validateTextField(mobileTextFiled, errorMessage: "Please enter your mobile number".localize),
            validateTextField(whatsAppNumberTextFiled, errorMessage: "Please enter your WhatsApp number".localize),
            validateTextField(emailTextFiled, errorMessage: "Please enter your email".localize),
            validateTextField(passwordTextField, errorMessage: "Please enter your password".localize),
            validateUIImage(storeLicenseImage, errorMessage: "Please Choose Store license image".localize),
            validateTextField(aboutCompanyTextField, errorMessage:  "Please enter about your company".localize),
            validateEmail()
            
            // More validations...
        ]
        
        return validateFieldsAndShowFirstError(validations: validations)
    }
    
    private  func validateEmail() -> ValidationResult {
        if isValidEmail(emailTextFiled.text!) {
            return .success
        } else {
            
            return .failure("Please enter a valid email".localize)
        }
        
    }
    private  func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    
    private func createStore(){
        let logoImage = storeLogoImage.jpegData(compressionQuality: 0.3)!
        let licenseImage = storeLicenseImage.jpegData(compressionQuality: 0.3)!
        
        self.registerButton.startAnimation()
        StoresController.shared.createStore(fullname: fullNameTextField.text.safeValue, mobile: (countryCode ?? "965") + mobileTextFiled.text.safeValue , whatsAppNum: whatsAppNumberTextFiled.text.safeValue, email: emailTextFiled.text.safeValue, activity: activityTextFiled.text.safeValue, countryCode: countryId, password: passwordTextField.text.safeValue, bio: aboutCompanyTextField.text.safeValue, logoImage:logoImage , licenseImage: licenseImage,cityId: "\(cityId)",catId: "\(mainCatID)",regionId: "\(stateId)",subCatId: "\(subCatID)",isCompany: isCompany, workTime: "") { data in
            
            self.registerButton.stopAnimation()
            guard let data = data else { return }
            
            do {
                let productObject = try JSONDecoder().decode(CreateStoreSuccessfulModel.self, from: data)
                
                if productObject.statusCode == 200{
                    
                    // navigate to success view
                    let successfullVC = CreateStoreSuccessfullyVC.instantiate()
                    successfullVC.modalPresentationStyle = .overFullScreen
                    self.present(successfullVC, animated: false)
                }
                else {
                    // error
                    let error = try JSONDecoder().decode(CreateStoreFailureModel.self, from: data)
                    
                    print(error.errors )
                    
                    let keysToCheck: [KeyPath<StoresErrors, [String]? >] = [
                        \.companyName, \.companyActivity, \.phone, \.email,
                         \.whatsapp, \.countryID, \.password, \.bio,
                         \.logo, \.license
                    ]
                    
                    if let firstErrorMessage = keysToCheck.compactMap({ error.errors[keyPath: $0]?.first }).first {
                        print("First error message:", firstErrorMessage)
                        StaticFunctions.createErrorAlert(msg: firstErrorMessage)
                    }
                    
                    
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                
            }
        }
    }
    // MARK: - IBActions
    
    
    
    @IBAction func didTapInstitutionButton(_ sender: UIButton) {
        setUpInstitutionButton()
        isCompany = 1
    }
    
    @IBAction func didTapIndividualButton(_ sender: UIButton) {
        setUpIndividualButton()
        isCompany = 0
        
        
    }
    
    
    @IBAction func didTapChangeLogo(_ sender: UIButton) {
        isStorelogo = true
        openGallery()
        //        let vc = EditStoreVC.instantiate()
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mainCatsBtnAction(_ sender: UIButton) {
        //        mainCatDropDwon.show()
        //        DispatchQueue.main.async {
        //
        let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: CATEGORY_VCID) as!  CategoryPopupViewController
        
        vc.categoryBtclosure = {
            (category) in
            self.mainCatID = category.id ?? 0
            if  MOLHLanguage.currentAppleLanguage() == "en" {
                
                self.mainCatName = category.nameEn ?? ""
            }
            else{
                self.mainCatName = category.nameAr ?? ""
            }
            
            self.getSubCats(catId:self.mainCatID )
            sender.setTitle(self.mainCatName, for: .normal)
            
            //            if self.mainCatID == 74 || self.mainCatID == 75 {
            //                self.rentViewContainer.isHidden = false
            //            }else {
            //                self.rentViewContainer.isHidden = true
            //            }
        }
        
        self.present(vc, animated: false, completion: nil)
        
        
    }
    
    @IBAction func subCatsBtnAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: SUB_CATEGORY_VCID) as!  SubcaregoryViewController
        vc.categoryId = mainCatID
        vc.categoryBtclosure = {
            (category) in
            
            self.subCatID = category.id ?? 0
            if  MOLHLanguage.currentAppleLanguage() == "en" {
                
                self.subCatName = category.nameEn ?? ""
            }
            else{
                self.subCatName = category.nameAr ?? ""
            }
            sender.setTitle(self.subCatName, for: .normal)
        }
        
        self.present(vc, animated: false, completion: nil)   
    }

  
    
    @IBAction func didTapChooseCountryButton(_ sender: UIButton) {
        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            if let url = URL(string:Constants.MAIN_DOMAIN + country.image.safeValue) {
                print(url)
                self.countryFlagImage.kf.setImage(with: url)
            }
            self.contryMobileCode.text = country.code ?? "965"
            self.countryCode = country.code ?? "965"
            self.countryName = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
            self.countryNameButton.setTitle(self.countryName, for: .normal)
            self.countryId = country.id ?? 6
            self.cityId = -1
            self.stateId = -1
            self.getCities()
        }
        self.present(coountryVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseCiityNameAction(_ sender: Any) {
        if countryId == -1{
            StaticFunctions.createErrorAlert(msg: "choose country first".localize)
            return
        }
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: CITIES_VCIID) as!  CitiesViewController
        vc.countryId = self.countryId
        vc.citiesBtclosure = {
            (city) in
           var name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
            self.cityBtn.setTitle(name, for: .normal)
            self.cityId = city.id ?? -1
            self.stateId = -1
            self.regonBtn.setTitle("", for: .normal)

            self.getAreas()
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func choosRegionNameAction(_ sender: Any) {
        if cityId == -1{
            StaticFunctions.createErrorAlert(msg: "choose city first".localize)
            return
        }
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: STATE_VCID) as!  StateViewController
        vc.countryId = self.cityId
        vc.citiesBtclosure = {
            (city) in
           var name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
            self.regonBtn.setTitle(name, for: .normal)
            self.stateId = city.id ?? -1
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didTapShowPasswordButton(_ sender: UIButton) {
        isPasswordHidden = !isPasswordHidden
        isPasswordHidden
        ? sender.setImage( UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal) : sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
        passwordTextField.isSecureTextEntry = isPasswordHidden
    }
    @IBAction func didTappickupCompanyLicenseButton(_ sender: UIButton) {
        isStorelogo = false
        openGallery()
        
    }
    @IBAction func didTapAgreeConditions(_ sender: UIButton) {
        isAgreeConditions = !isAgreeConditions
        isAgreeConditions ? sender.setImage( UIImage(named: "checkButtonImage")?.withRenderingMode(.alwaysTemplate), for: .normal) : sender.setImage(UIImage(named:"uncheckButtonImage"), for: .normal)
    }
    @IBAction func didTapShowConditions(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapPickupLicenseImage(_ sender: UIButton) {
        isStorelogo = false
        openGallery()
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        if validateAndPrintMessages()  && isAgreeConditions{
            createStore()
        }else if !isAgreeConditions {
            StaticFunctions.createErrorAlert(msg: "You must agree to the terms and conditions".localize)
        }
        
    }
    
    @IBAction func didTaplogin(_ sender: UIButton) {
        
    }
    
    //MARK: Methods
    
    private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
 
    
  
    
    
    
}
extension CreateStoreVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let capturedImage = info[.originalImage] as? UIImage {
            print("Captured image: \(capturedImage)")
            // self.images.append(capturedImage as UIImage)
            
            if isStorelogo{
                self.storeLogoImage = capturedImage
                self.storeImageView.image = capturedImage
            }else{
                self.licenseImageView.image = capturedImage
                self.storeLicenseImage = capturedImage
                self.licenseImageView.isHidden = false

            }
            
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension CreateStoreVC {
    func getCities(){
        CountryController.shared.getCities(completion: {
            countries, check,msg in
            Constants.CITIES = countries
            if Constants.CITIES.count > 0{
                self.cityId = Constants.CITIES[0].id ?? -1
                self.cityBtn.setTitle(MOLHLanguage.currentAppleLanguage() == "en" ? Constants.CITIES[0].nameEn : Constants.CITIES[0].nameAr, for: .normal)
                self.getAreas()
            }
        }, countryId: countryId)
    }
    func getAreas(){
        CountryController.shared.getStates(completion: {
            countries, check,msg in
            Constants.STATUS = countries
            if Constants.STATUS.count > 0{
                self.stateId = Constants.STATUS[0].id ?? -1
                self.regonBtn.setTitle(MOLHLanguage.currentAppleLanguage() == "en" ? Constants.STATUS[0].nameEn : Constants.STATUS[0].nameAr, for: .normal)
            }
        }, countryId: cityId)
    }
    
    private  func getMainCats(){
        CategoryController.shared.getCategoories { [weak self]categories, check, error in
            guard let self = self else {return}
            
            for cat in categories {
                if MOLHLanguage.currentAppleLanguage() == "en"{
                    self.mainCatsList.append(cat.nameEn ?? "")
                    self.mainCatsIDsList.append(cat.id ?? 0)
                    print(self.mainCatsIDsList)
                    print(self.mainCatsList)
                }else{
                    self.mainCatsList.append(cat.nameAr ?? "")
                    self.mainCatsIDsList.append(cat.id ?? 0)
                    print(self.mainCatsIDsList)
                    print(self.mainCatsList)
                }
            }
            if self.mainCatID == -1 {
                self.mainCatID = self.mainCatsIDsList[0]
            }
            mainCatBtn.setTitle(mainCatsList.first, for: .normal)
            self.getSubCats(catId: self.mainCatID)
        }
    }
    
    private  func getSubCats(catId:Int){
        CategoryController.shared.getSubCategories(completion: {[weak self] subCategories, check, error in
            guard let self = self else {return}
            self.subCatsList.removeAll()
            self.subCatsIDsList.removeAll()
            for cat in subCategories {
                if MOLHLanguage.currentAppleLanguage() == "en"{
                    self.subCatsList.append(cat.nameEn ?? "")
                    self.subCatsIDsList.append(cat.id ?? 0)
                    print(self.subCatsIDsList)
                }else{
                    self.subCatsList.append(cat.nameAr ?? "")
                    self.subCatsIDsList.append(cat.id ?? 0)
                    print(self.subCatsIDsList)
                }
            }
            subCatBtn.setTitle(subCatsList.first, for: .normal)
            
        }, categoryId: catId)
    }
}
