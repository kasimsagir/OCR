//
//  AppDelegate.swift
//  OCRProject
//
//  Created by Kasım Sağır on 17.11.2020.
//

import UIKit
import IQKeyboardManagerSwift
import PKHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Bitti"
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        
        return true
    }
}

