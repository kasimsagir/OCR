//
//  MedicineCell.swift
//  OCRProject
//
//  Created by Kasım Sağır on 9.03.2021.
//

import UIKit

class MedicineCell: UITableViewCell {
    
    @IBOutlet weak var medicineImageView: UIImageView! {
        didSet {
            medicineImageView.layer.cornerRadius = 8
            medicineImageView.layer.borderWidth = 1
            medicineImageView.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var medicineBrandLabel: UILabel!
    @IBOutlet weak var medicineSKTLabel: UILabel!
    @IBOutlet weak var medicineGramajLabel: UILabel!
    @IBOutlet weak var medicineDescriptionLabel: UILabel!
    
    
    func setMedicine(_ medicine: MedicineDAO){
        
    }
}
