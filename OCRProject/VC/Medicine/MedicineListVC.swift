//
//  MedicineListVC.swift
//  OCRProject
//
//  Created by Kasım Sağır on 9.03.2021.
//

import UIKit
import Vision
import VisionKit
import AVFoundation
import Speech

class MedicineListVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    let audioEngine = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer?
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var medicineList: [UserMedicineDAO] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var refreshControl = UIRefreshControl()
    var isNavigated: Bool = false
    var isRemove = false
    let localMedicines = MedicineManager.shared.getAllObjects
    
    override func viewDidLoad() {
        navigationItem.title = "İlaçlarım"
        navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.addRightButtonOnKeyboardWithImage(UIImage.add, target: self, action: #selector(addNewMedicine))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMedicine))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showNotifications))
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        refreshControl.beginRefreshing()
        if !UserManager.isOffline {
            getMedicineList()
        }
        setupSpeechRecognizer()
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            print("TESTTTT")
            self.cancelRecording()
            self.recordAndRecognizeSpeech()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isNavigated = false
    }
    
    @objc func showNotifications(){
        navigateToNotifications()
    }
    
    @objc func addNewMedicine(){
        navigateToNewMedicine(isPan: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getMedicineList()
    }
}

// MARK: - TableView Delegate & DataSource
extension MedicineListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? MedicineManager.shared.getAllObjects.count : medicineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineCell
            cell.setMedicine(MedicineManager.shared.getAllObjects[indexPath.row])
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineCell
            cell.setMedicine(medicineList[indexPath.row])
            return cell
        }
        
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineCell
//            cell.setMedicine(medicineList[indexPath.section])
//            return cell
//        }else {
//            let cell = UITableViewCell()
//            let index = indexPath.row+1
//            let medicine = medicineList[indexPath.section]
//            let day = index/medicine.repeatDay
//            let count = index - (day*medicine.repeatDay) + 1
//
//            cell.accessoryType = indexPath.row == 1 ? .checkmark : .disclosureIndicator
//            cell.textLabel?.text = "\(day). günün \(count) ilacı"
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToOCR(medicineList[indexPath.section].medicineDAO)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Kendi Eklediğim İlaçlar" : "Doktorun Eklediği İlaçlar"
    }
}

// MARK: - Services
extension MedicineListVC {
    func getMedicineList() {
        UserControllerAPI.getUserMedicinesUsingGET(_id: UserManager.shared.savedUserId) { [unowned self] (medicineList, error) in
            refreshControl.endRefreshing()
            if error == nil {
                self.medicineList = medicineList?.data ?? []
                if self.medicineList.isEmpty {
//                    self.speechText("Hiç ilaç bulunamadı. İlaç eklemesi için doktorunuzla iletişime geçiniz.")
                    self.tableView.showEmptyLabel(message: "Hiç ilaç bulunamadı. İlaç eklemesi için doktorunuzla iletişime geçiniz.", containerView: self.tableView)
                }else {
//                    let medicineString = self.medicineList.map { (medicine) -> String in
//                        return medicine.medicineDAO.name ?? ""
//                    }.joined(separator: ", ")
                    self.speechText("\(self.medicineList.count) adet ilaç bulundu. Kameraya tanıtmak için ilacın ismini söyleyin.")
                    self.tableView.hideEmptyLabel()
                }
            }else {
                AlertView.show(in: self, title: "Uyarı", message: "Bir hata oluştu. \(error?.localizedDescription ?? "")")
            }
        }
    }
}

//MARK: - Speech & Recognize
extension MedicineListVC {
    func setupSpeechRecognizer(){
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TR"))
        
        self.requestSpeechAuthorization()
    }
    

    
    //MARK: - Recognize Speech
    func recordAndRecognizeSpeech() {
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Speech Recognizer Error: There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            print("Speech Recognizer Error: Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            print("Speech Recognizer Error: Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                self.checkForColorsSaid(resultString: lastString)
            } else if let error = error {
                print("Speech Recognizer Error: There has been a speech recognition error.")
                print(error)
            }
        })
    }
    
    func checkForColorsSaid(resultString: String) {
        print("SONUÇ: \(resultString)")
        if resultString == "vazgeç" || resultString == "Vazgeç" {
            isRemove = false
        }
        if isRemove {
            if let medicine = findLocalMedicines(resultString), medicine != "" {
                isRemove = false
                removeWarning(medicine: medicine)
            }
        }
        if resultString == "yeni" || resultString == "Yeni" {
            cancelRecording()
            navigateToNewMedicine()
        }
        if resultString == "çıkış" || resultString == "Çıkış" {
            logout()
        }
        if resultString == "sil" || resultString == "Sil" {
            removeMedicine()
        }
        let selectedMedicine = medicineList.filter { (medicine) -> Bool in
            return medicine.medicineDAO.name?.lowercased() == resultString.lowercased()
        }
        if selectedMedicine.count != 0 {
            cancelRecording()
            navigateToOCR(selectedMedicine.first?.medicineDAO)
        }
    }
    
    func logout(){
        self.speechText("Çıkış yapmak istediğinize emin misiniz?")
        AlertView.showYesNo(in: self, title: "Uyarı", message: "Çıkış yapmak istediğinize emin misiniz?", butonTitle: "Çıkış Yap") { () -> (Void) in
            UserManager.shared.saveToken("")
            UserManager.shared.saveUser("", "", "", "", "")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func removeMedicine() {
        AlertView.show(in: self, title: "Bilgi", message: "Silmek istediğiniz ilacın ismini söyleyiniz?")
        isRemove = true
    }
    
    func removeWarning(medicine: String){
        self.speechText("Silmek istediğiniz ilacın ismini söyleyiniz?")
        AlertView.showYesNo(in: self, title: "Uyarı", message: "\(medicine), ilacını silmek istediğinize emin misiniz?", butonTitle: "Sil") { () -> (Void) in
            let temp = MedicineManager.shared.getAllObjects
            let removedList = temp.filter { (user) -> Bool in
                return user.medicineDAO.name != medicine
            }
            MedicineManager.shared.saveAllObjects(allObjects: removedList)
        }
    }
    
    func findLocalMedicines(_ medicineName: String)-> String?{
        for item in localMedicines {
            if item.medicineDAO.name?.uppercased() == medicineName.uppercased() {
                return medicineName
            }
        }
        return nil
    }
    
    func cancelRecording() {
        DispatchQueue.main.async {
//            self.recognitionTask?.finish()
//            self.recognitionTask = nil
//
//            // stop audio
//            self.request.endAudio()
//            self.audioEngine.stop()
//            self.audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:break
                    //                        self.startButton.isEnabled = true
                    case .denied:break
                    //                        self.startButton.isEnabled = false
                    //                        self.detectedTextLabel.text = "User denied access to speech recognition"
                    case .restricted:break
                    //                        self.startButton.isEnabled = false
                    //                        self.detectedTextLabel.text = "Speech recognition restricted on this device"
                    case .notDetermined:break
                    //                        self.startButton.isEnabled = false
                    //                        self.detectedTextLabel.text = "Speech recognition not yet authorized"
                    @unknown default:
                        return
                }
            }
        }
    }
}

//MARK: - Helper
extension MedicineListVC {
    func navigateToOCR(_ medicine: MedicineDAO? = nil){
        if !isNavigated {
            isNavigated = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TextRecogVC") as! TextRecogVC
            vc.medicine = medicine
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToNewMedicine(isPan: Bool = false){
        if isPan {
            let vc = NewMedicineVC()
            vc.delegate = self
            presentPanModal(vc)
        }else if !isNavigated {
            isNavigated = true
            let vc = NewMedicineVC()
            presentPanModal(vc)
        }
    }
    
    func navigateToNotifications(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
//        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MedicineListVC: NewMedicineVCDelegate {
    func refresh() {
        self.tableView.reloadData()
    }
    
    func missingText(medicine: UserMedicineDAO) {
        AlertView.show(in: self, title: "Hata", message: "Lütfen ilaç bilgilerini eksiksiz giriniz.") {
            let vc = NewMedicineVC()
            vc.delegate = self
            vc.newMedicine = medicine
            self.presentPanModal(vc)
        }
        
    }
}

extension UIViewController {
    func speechText(_ speechText: String){
        //        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: speechText)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 3.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        speechSynthesizer.speak(speechUtterance)
    }
}
