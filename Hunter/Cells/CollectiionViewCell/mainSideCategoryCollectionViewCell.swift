//
//  mainSideCategoryCollectionViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 03/05/2023.
//

import UIKit
import MOLH

class mainSideCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageBackView: UIView!
    
    @IBOutlet weak var cImageView: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var divider: UIView!
    
    func setData(category:Category) {
        if let name = category.nameEn  {
            if name.contains("tour"){
                if  MOLHLanguage.currentAppleLanguage() == "en" {
                    lbl_name.text = category.nameEn ?? category.nameAr ?? ""
                }
                else{
                    lbl_name.text = category.nameAr ?? category.nameEn ?? ""
                    
                }
                cImageView.image = UIImage(named: "tourguide")
                cImageView.contentMode = .scaleAspectFit
                imageBackView.backgroundColor = UIColor(named: "#0EBFB1") ?? .yellow
            }
            else{
                if  MOLHLanguage.currentAppleLanguage() == "en" {
                    lbl_name.text = category.nameEn ?? category.nameAr ?? ""
                }
                else{
                    lbl_name.text = category.nameAr ?? category.nameEn ?? ""
                    
                }
                cImageView.setImageWithLoading(url: category.image ?? "")
//                imageBackView.backgroundColor = .clear
            }
        }
        
       
    }
    override var isSelected: Bool {
        didSet {
            if isSelected{
                backgroundColor = UIColor(named: "#F5F5F5")
                
                imageBackView.backgroundColor = UIColor.white
                divider.backgroundColor = UIColor(named: "#0093F5")
            }else{
                backgroundColor = .clear
                imageBackView.backgroundColor = UIColor(named: "#F5F5F5")
                
                divider.backgroundColor = .clear
            }
            
            
        }
        
    }
    
    
    
    
}
