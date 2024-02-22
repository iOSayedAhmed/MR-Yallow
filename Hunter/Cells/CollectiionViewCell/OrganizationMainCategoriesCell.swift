//
//  OrganizationMainCategoriesCell.swift
//  NewBazar
//
//  Created by iOSAYed on 18/02/2024.
//

import UIKit
import SDWebImage
import MOLH

class OrganizationMainCategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryContainerView: UIView!
//    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override var isSelected: Bool {
            didSet {
                self.contentView.backgroundColor = isSelected ? UIColor(named: "#707070") : UIColor(named: "#FFFFFF")
                self.titleLbl.textColor = isSelected ? UIColor(named: "#0093F5") : UIColor(named: "#929292")

            }
          
        }
    func setData(category: Category){
//        if category.id == -1{
//            categoryImageView.image = UIImage(named: "CategoryIcon")
//        }else{
//            categoryImageView.setImageWithLoading(url: category.image ?? "")
//            sd_setImage(with: URL(string: category.image ?? ""), placeholderImage: UIImage(named: "logo_Bazar"))
//        }
        
      //  categoryImageView.sd_setImage(with: URL(string: category.image ?? ""), placeholderImage: UIImage(named: "logo_Bazar"))
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            
            titleLbl.text = category.nameEn ??  category.nameAr ?? ""
        }
        
        else{
            titleLbl.text = category.nameAr ?? category.nameEn ?? ""

        }
    }
    
}
