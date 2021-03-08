//
//  BaseVC.swift
//  OCRProject
//
//  Created by Kasım Sağır on 8.03.2021.
//

import UIKit
import PKHUD

class BaseVC: UIViewController {
    
    func showLoading(){
        PKHUD.sharedHUD.show()
    }
    
    func hideLoading(){
        PKHUD.sharedHUD.hide(true)
    }
}
