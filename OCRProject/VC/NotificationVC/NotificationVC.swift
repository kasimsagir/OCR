//
//  NotificationVC.swift
//  OCRProject
//
//  Created by Kasım Sağır on 30.06.2021.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notificationList: [LogData] = []
    
    override func viewDidLoad() {
        if !UserManager.isOffline {
            useMedicine()
        }
    }
    
    func useMedicine(){
        MedicineControllerAPI.getLogsUsingGET() { [unowned self] (commonResponse, error) in
            if error == nil {
                self.notificationList = commonResponse?.data ?? []
                tableView.reloadData()
                if self.notificationList.isEmpty {
                    self.tableView.showEmptyLabel(message: "Bildirim bulunamadı.", containerView: view)
                }else {
                    self.tableView.hideEmptyLabel()
                }
            }else {
                AlertView.show(in: self, title: "Uyarı", message: "Bir hata oluştu. \(error?.localizedDescription ?? "")")
            }
        }
    }
}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(notificationList[indexPath.row].medicineDAO) ilacı için hatalı giriş bulundu. Lütfen tekrar deneyiniz."
        cell.detailTextLabel?.text = notificationList[indexPath.row].date
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
