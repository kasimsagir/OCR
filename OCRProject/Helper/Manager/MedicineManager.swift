//
//  MedicineManager.swift
//  OCRProject
//
//  Created by Kasım Sağır on 30.06.2021.
//

import Foundation

class MedicineManager: NSObject {
    
    static var shared = MedicineManager()
    
    var getAllObjects: [UserMedicineDAO] {
        if let objects = UserDefaults.standard.value(forKey: "user_objects") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [UserMedicineDAO] {
                return objectsDecoded
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    func saveAllObjects(allObjects: [UserMedicineDAO]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allObjects){
            UserDefaults.standard.set(encoded, forKey: "user_objects")
        }
    }
    
    func saveObject(object: UserMedicineDAO) {
        var tmp = MedicineManager.shared.getAllObjects
        tmp.append(object)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tmp){
            UserDefaults.standard.set(encoded, forKey: "user_objects")
        }
    }
}
