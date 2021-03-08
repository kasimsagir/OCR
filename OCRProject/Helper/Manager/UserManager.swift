//
//  UserManager.swift
//  OCRProject
//
//  Created by Kasım Sağır on 9.03.2021.
//

import Foundation
import UIKit

class UserManager: NSObject {
    
    static var shared = UserManager()
    
    // MARK: Generic Propeties
    var savedToken: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedToken) ?? ""
    }
    
    var savedUserId: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUserId) ?? ""
    }
    
    var savedUsername: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUsername) ?? ""
    }
    
    var savedEmail: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedEmail) ?? ""
    }
    
    var savedName: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedName) ?? ""
    }
    
    var savedSurname: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedSurname) ?? ""
    }
    
    var savedFCMToken: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedFCMToken) ?? ""
    }
    
    var savedPhoneNumber: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedPhoneNumber) ?? ""
    }
    
    var savedcompanyImage: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedCompanyImage) ?? ""
    }
    
    var savedcompanyValue: String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.savedCompanyValue) ?? ""
    }
    
    var nonMemberUser: Bool {
        return savedToken == "" ? true : false
    }
}
// MARK: - Functions
extension UserManager {
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.savedToken)
    }
    
    private func saveUserId(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.savedUserId)
    }
    
    private func saveUsername(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.savedUsername)
    }
    
    private func saveEmail(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.savedEmail)
    }
    
    private func saveName(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.savedName)
    }
    
    private func saveSurname(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.savedSurname)
    }
    
    func saveFCMToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.savedFCMToken)
    }
    
    private func savePhoneNumber(_ phoneNumber: String) {
        UserDefaults.standard.set(phoneNumber, forKey: Constants.UserDefaults.savedPhoneNumber)
    }
    
    func saveCompanyImage(_ companyImage: String) {
        UserDefaults.standard.set(companyImage, forKey: Constants.UserDefaults.savedCompanyImage)
    }
    
    func saveCompanyValue(_ companyValue: String) {
        UserDefaults.standard.set(companyValue, forKey: Constants.UserDefaults.savedCompanyValue)
    }
    
    func saveUser(_ userId: String, _ email: String, _ name: String, _ surname: String){
        saveUserId(userId)
        saveEmail(email)
        saveName(name)
        saveSurname(surname)
    }
}
