//
//  AlertView.swift
//  OCRProject
//
//  Created by Kasım Sağır on 8.03.2021.
//

import UIKit

class AlertView {
    
    static func show(in viewController: UIViewController, title: String?, message: String?) {
        viewController.speechText(message ?? "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showError(in viewController: UIViewController, message: String?) {
        let alert = UIAlertController(title: "Hata", message: message ?? "errorHappenedTryAgain", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    
    static func show(in viewController: UIViewController, title: String?, message: String?, completion : @escaping () -> (Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { action in
            completion()
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func tryAgain(in viewController: UIViewController, title: String?, message: String?, completion : @escaping () -> (Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default) { action in
            completion()
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showWithCancelButton(in viewController: UIViewController, title: String?, message: String?, completion : @escaping () -> (Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { action in
            completion()
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showYesNo(in viewController: UIViewController, title: String?, message: String?, butonTitle: String?, completion : @escaping () -> (Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        alert.addAction(UIAlertAction(title: butonTitle, style: .default) { action in
            completion()
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showWithTextField(in viewController: UIViewController, title: String?, message: String?, completion: @escaping (_ entredValue: String?) -> Void) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = message
        }
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0]
            completion(textField?.text)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showNotification(in viewController: UIViewController, message: String?, completion : @escaping () -> (Void)) {
        
        let alert = UIAlertController(title: "newNotification", message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Kapat", style: .cancel))
        alert.addAction(UIAlertAction(title: "show", style: .default) { action in
            completion()
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
    static func alertWithTextField(in viewController: UIViewController, title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel) { _ in completion("") })
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        viewController.present(alert, animated: true)
    }
}
