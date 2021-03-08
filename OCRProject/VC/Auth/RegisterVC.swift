//
//  RegisterVC.swift
//  OCRProject
//
//  Created by Kasım Sağır on 8.03.2021.
//

import UIKit

class RegisterVC: BaseVC {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!

}

// MARK: - Button Actions
extension RegisterVC {
    @IBAction func registerAction(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            AlertView.show(in: self, title: "Uyarı", message: "Lütfen adınızı giriniz.")
            return
        }
        
        guard let surname = surnameTextField.text, !name.isEmpty else {
            AlertView.show(in: self, title: "Uyarı", message: "Lütfen soyadınızı giriniz.")
            return
        }
        
        guard let email = emailTextField.text, !name.isEmpty else {
            AlertView.show(in: self, title: "Uyarı", message: "Lütfen emailinizi giriniz.")
            return
        }
        
        guard let password = passwordTextField.text, !name.isEmpty else {
            AlertView.show(in: self, title: "Uyarı", message: "Lütfen şifrenizi giriniz.")
            return
        }
        
        guard let gender = RegisterRequestDTO.Sex(rawValue: genderTextField.text?.uppercased() ?? ""), !name.isEmpty else {
            AlertView.show(in: self, title: "Uyarı", message: "Lütfen cinsiyetinizi giriniz.")
            return
        }
        
        guard let weight = Double(weightTextField.text ?? ""), !name.isEmpty else {
            AlertView.show(in: self, title: "Uyarı", message: "Lütfen kilonuzu giriniz.")
            return
        }
        
        guard let age = Int(ageTextField.text ?? ""), !name.isEmpty else {
            AlertView.show(in: self, title: "Uyarı", message: "Lütfen yaşınızı giriniz.")
            return
        }
        
        registerService(RegisterRequestDTO(age: age,
                                           email: email,
                                           name: name,
                                           password: password,
                                           sex: gender,
                                           surname: surname,
                                           type: .normal,
                                           weight: weight))
    }
}

// MARK: - Services
extension RegisterVC {
    func registerService(_ user: RegisterRequestDTO){
        showLoading()
        AccountControllerAPI.registerUsingPOST(registerRequestDTO: user) { [unowned self] (user, error) in
            hideLoading()
            if error == nil {
                AlertView.show(in: self, title: "Başarılı", message: "Üyeliğiniz başarıyla oluşturuldu.\nLütfen giriş yapınız.") { () -> (Void) in
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                AlertView.show(in: self, title: "Uyarı", message: "Bir hata oluştu. \(error?.localizedDescription ?? "")")
            }
        }
    }
}
