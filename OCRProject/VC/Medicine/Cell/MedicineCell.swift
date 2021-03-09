//
//  MedicineCell.swift
//  OCRProject
//
//  Created by Kasım Sağır on 9.03.2021.
//

import UIKit
import Kingfisher

class MedicineCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 16
        }
    }
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
    @IBOutlet weak var repeatLabel: UILabel!
    
    
    func setMedicine(_ medicine: UserMedicineDAO){
        let url = URL(string: medicine.medicineDAO.photoPath)
        medicineImageView.kf.setImage(with: url)
        medicineNameLabel.text = medicine.medicineDAO.name
        medicineBrandLabel.text = medicine.medicineDAO.brand
        medicineSKTLabel.text = medicine.medicineDAO.skt
        medicineGramajLabel.text = medicine.medicineDAO.gramaj
        medicineDescriptionLabel.text = medicine.medicineDAO._description
        repeatLabel.text = "Günde \(medicine.repeatDaily) defa\n\(medicine.repeatDay) gün boyunca"
    }
}
