//
//  LoginVC.swift
//  OCRProject
//
//  Created by Kasım Sağır on 8.03.2021.
//

import UIKit

class LoginVC: BaseVC {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {

    }
}

// MARK: - Button Actions
extension LoginVC {
    @IBAction func loginAction(_ sender: UIButton) {
        if let username = usernameTextField.text,
           username.isEmail() {
            if let password = passwordTextField.text,
               !password.isEmpty {
                loginService(username, password)
            }else {
                AlertView.show(in: self, title: "Uyarı", message: "Lütfen şifre giriniz.")
            }
        }else {
            AlertView.show(in: self, title: "Uyarı", message: "Lütfen geçerli email giriniz.")
        }
    }
}

// MARK: - Services
extension LoginVC {
    func loginService(_ email: String, _ password: String) {
        showLoading()
        AccountControllerAPI.loginUsingPOST(loginRequestDTO: LoginRequestDTO(email: email, password: password)) { [unowned self] (user, error) in
            hideLoading()
            if error == nil {
                UserManager.shared.saveUser(user?.data?._id ?? "",
                                            user?.data?.email ?? "",
                                            user?.data?.name ?? "",
                                            user?.data?.surname ?? "",
                                            user?.data?.authorizationKey ?? "")
                navigateToMedicineList()
            }else {
                AlertView.show(in: self, title: "Uyarı", message: "Bir hata oluştu. \(error?.localizedDescription ?? "")")
            }
        }
    }
}

// MARK: - Helper
extension LoginVC {
    func navigateToMedicineList(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MedicineListVC") as! MedicineListVC
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}
