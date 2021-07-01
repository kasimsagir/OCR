//
//  ViewController.swift
//  Oyun Takipçisi
//
//  Created by Kasım Sağır on 4.04.2021.
//

import UIKit

class SplashVC: BaseVC {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            if UserManager.shared.savedToken != "" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MedicineListVC") as! MedicineListVC
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.setViewControllers([vc], animated: true)
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let navigationController = UINavigationController(rootViewController: vc)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }

}

