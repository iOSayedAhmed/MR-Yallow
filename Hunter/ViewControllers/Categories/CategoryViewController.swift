//
//  CategoryViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 03/05/2023.
//

import UIKit
import WoofTabBarController
import MOLH

class CategoryViewController: UIViewController {
    
    static func instantiate()->CategoryViewController{
        let controller = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"categories") as! CategoryViewController
        return controller
    }
    
    @IBOutlet weak var sideCategoyCollectionView: UICollectionView!
    @IBOutlet weak var listMainCategory: UICollectionView!
    
    var categories = [Category]()
    var sideCatgeory = [Category]()
    var categoryIndex = 0
    var cities = [Country]()
    var isTourGuide = false
    var animatedIndexPaths: Set<IndexPath> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        self.navigationItem.title = "Categories".localize
//        getCities()
        getCategory()
        sideCategoyCollectionView.semanticContentAttribute = .forceLeftToRight
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isTourGuide = false
    }
}
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == listMainCategory{
            return categories.count
        }else{
            if categoryIndex != (categories.count-1) {
                return sideCatgeory.count
            }else{
                return cities.count
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == listMainCategory{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath) as! mainSideCategoryCollectionViewCell
            cell.setData(category: categories[indexPath.row])
            return cell
        }else{
            if  categoryIndex != (categories.count-1){
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatSideCell", for: indexPath) as! SideCategoryCollectionViewCell
                cell.setData(category: sideCatgeory[indexPath.row])
                
                return cell
            }else{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ask_cell", for: indexPath) as! AskSubCategoryCollectionViewCell
                cell.setData(city: cities[indexPath.row])
                return cell
                
            }
        }
        }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == listMainCategory{
            return CGSize(width: 110, height: 82)
        }else {
            return CGSize(width: collectionView.frame.width/2 - 5, height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == listMainCategory{
            if indexPath.row != categories.count-1 {
                self.categoryIndex = indexPath.row
                self.getSubCategory()
            }else {
                self.categoryIndex = indexPath.row
                getCities()
            }
            
            
        } else{
            if categoryIndex != (categories.count-1){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"chooseCategory"), object: nil, userInfo: ["cat_index": categoryIndex, "sub_cat_index": indexPath.row, "subCategories": sideCatgeory])
                print("categoryIndex" , categoryIndex)
                print("sub_cat_index" , indexPath.row)
                print("subCategories" ,sideCatgeory )
                let homeDetailsVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "homeDetails") as! HomeDetailsViewController
                homeDetailsVC.selectedCategoryIndex = categoryIndex 
                homeDetailsVC.selectedSubCategoryIndex = indexPath.row
                homeDetailsVC.mainCategory = MOLHLanguage.isArabic() ? categories[indexPath.row].nameAr ?? "" :categories[indexPath.row].nameEn ?? ""
                homeDetailsVC.isComeFromMainCategory = true
                homeDetailsVC.subCategories = sideCatgeory
                homeDetailsVC.categories = categories
                homeDetailsVC.isComeFromCategory = true
                homeDetailsVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(homeDetailsVC, animated: true)
//            self.navigationController?.popViewController(animated: true)
            
            }else{
                if StaticFunctions.isLogin(){
                let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: ASK_CITY_VCID) as! AsksViewController
                vc.cityId = cities[indexPath.row].id ?? 46
                self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
                }
                
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if we've already animated this cell
        if !animatedIndexPaths.contains(indexPath) {
            // Start with the cell fully out of view to the right
            cell.transform = CGAffineTransform(translationX: collectionView.bounds.size.width, y: 0)
            
            // Animate the cell to slide in from the right to its normal position
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform.identity
            }) { _ in
                // Animation completed
                self.animatedIndexPaths.insert(indexPath) // Mark this indexPath as animated
            }
        }
    }


}
extension CategoryViewController{
    func getCategory(){
        animatedIndexPaths.removeAll()
        CategoryController.shared.getCategoories(completion: {
            categories, check, msg in
            
            self.categories = categories
            if self.categories.count > 0{
                print(categories)
                self.categories.append(Category(nameAr: "مرشد سياحي", nameEn: "tour guide", id: 2, hasSubCat: 0))
                if !self.isTourGuide {
                    self.categoryIndex = 0
                    self.getSubCategory()
                }else {
                    self.categoryIndex = self.categories.count - 1
                    self.getCities()
                }
                
               
            }
            self.listMainCategory.reloadData()
            
            if !self.isTourGuide {
                self.listMainCategory.selectItem(at: [0,0], animated: false, scrollPosition: .centeredVertically)
            }else {
                self.listMainCategory.selectItem(at: [0,(self.categories.count - 1)], animated: false, scrollPosition: .centeredVertically)
            }
            
            
            
        })
    }
    func getSubCategory(){
        CategoryController.shared.getSubCategories(completion: {
            categories, check, msg in
            self.sideCatgeory.removeAll()
            
            print(categories.count)
            self.sideCatgeory = categories
            
            if categories.count > 0 {
                self.sideCategoyCollectionView.isHidden = false
            }else{
                self.sideCategoyCollectionView.isHidden = true
                
            }
            
            self.sideCategoyCollectionView.reloadData()
            
            
        }, categoryId: self.categories[categoryIndex].id ?? 0)
    }
    func getCities(){
        if AppDelegate.currentCountry.id == 5 || AppDelegate.currentCountry.id == 10{
            CountryController.shared.getCities(completion: {
                countries, check,msg in
                self.cities = countries
                print(countries)
            }, countryId: AppDelegate.currentCountry.id ?? 0)
        }else{
            //asks_side
            self.cities = [ Country(nameAr: AppDelegate.currentCountry.nameAr ?? "الكويت", nameEn:  AppDelegate.currentCountry.nameEn ?? "Kuwait", id: AppDelegate.currentCountry.id  ?? 6)]
            
        }
        
        self.sideCategoyCollectionView.isHidden = self.cities.count == 0 ?   true : false
        
        DispatchQueue.main.async { [weak self]  in
            self?.sideCategoyCollectionView.reloadData()
        }
    }
}
//extension CategoryViewController:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {
//    
//    func woofTabBarItem() -> WoofTabBarItem {
//        return WoofTabBarItem(title: "Categories".localize, image: "CategoryIcon", selectedImage: "CategoryButtonIcon")
//    }
//}
