//
//  NotificationVC.swift
//  OCRProject
//
//  Created by Kasım Sağır on 30.06.2021.
//

import UIKit

class NotificationVC: UIViewController {
    
    var notificationList = [
        "Dikkat 20 Haziran tarihinde Aspirin ilacını almadınız.",
        "Dikkat 20 Haziran tarihinde hatalı ilaç okuttunuz."
    ]
    
}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = notificationList[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(named: "warningW")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
