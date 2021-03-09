//
//  TableViewExtension.swift
//  OCRProject
//
//  Created by Kasım Sağır on 9.03.2021.
//

import UIKit

extension UITableView {
    func showEmptyLabel(message: String, containerView: UIView) {
        DispatchQueue.main.async {
            let messageLabel = UILabel(frame: CGRect(x: 20, y: 0, width: containerView.bounds.size.width-60, height: containerView.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = UIColor.red
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.sizeToFit()
            
            self.backgroundView = messageLabel
        }
    }
    
    func hideEmptyLabel(){
        DispatchQueue.main.async {
            self.backgroundView = UIView()
        }
    }
}
