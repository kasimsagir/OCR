//
//  TextRecogVC.swift
//  OCRProject
//
//  Created by Kasım Sağır on 9.03.2021.
//

import UIKit
import Vision
import AVFoundation

class TextRecogVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var previewView: PreviewView!
    
    private var requests = [VNRequest]()
    private let session = AVCaptureSession()
    var medicine: MedicineDAO?
    var isFind: Bool = false
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        setupVision()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deactivateVision()
    }
    
    // MARK: - Vision Setup
    func setupVision() {
        let textRequest = VNRecognizeTextRequest(completionHandler: self.textDetectionHandler)
        textRequest.recognitionLevel = .accurate
        
        self.requests = [textRequest]
    }
    
    func textDetectionHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        if recognizedStrings != [], !isSearching {
            isSearching = true
            DispatchQueue.main.asyncAfter(deadline: .now()+5) { [weak self] in
                guard let self = self else { return }
                if !self.isFind {
                    self.useMedicine(isLog: true)
                }
            }
        }
        print(recognizedStrings)
        if let medicineName = medicine?.name {
            if recognizedStrings.contains(where: { (string) -> Bool in
                return string.uppercased() == medicineName.uppercased()
            }) {
                DispatchQueue.main.async {
                    self.session.stopRunning()
                    self.useMedicine()
                }
            }
            
        }
    }
    
    func useMedicine(isLog: Bool = false){
        if UserManager.isOffline {
            if isLog {
                AlertView.show(in: self, title: "Uyarı", message: "Yanlış ilaç, lütfen tekrar deneyiniz.") { () -> (Void) in
                    self.deactivateVision()
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                AlertView.show(in: self, title: "Başarılı", message: "Doğru ilaç, lütfen ilacınızı kullanın.") { () -> (Void) in
                    self.deactivateVision()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            isFind = true
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let someDateTime = formatter.string(from: Date())
            MedicineControllerAPI.useMedicineUsingPUT(date: someDateTime, _id: medicine?._id ?? "", isLog: isLog) { [unowned self] (medicineList, error) in
                if error == nil {
                    if isLog {
                        AlertView.show(in: self, title: "Uyarı", message: "Yanlış ilaç, doktorunuza iletildi.") { () -> (Void) in
                            self.deactivateVision()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else {
                        AlertView.show(in: self, title: "Başarılı", message: "Doğru ilaç, lütfen ilacınızı kullanın.") { () -> (Void) in
                            self.deactivateVision()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }else {
                    AlertView.show(in: self, title: "Uyarı", message: "Bir hata oluştu. \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    func deactivateVision(){
        self.requests = []
    }
    
    // MARK: - Draw
    func drawRegionBox(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else {return}
        var xMin: CGFloat = 9999.0
        var xMax: CGFloat = 0.0
        var yMin: CGFloat = 9999.0
        var yMax: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < xMin {xMin = char.bottomLeft.x}
            if char.bottomRight.x > xMax {xMax = char.bottomRight.x}
            if char.bottomRight.y < yMin {yMin = char.bottomRight.y}
            if char.topRight.y > yMax {yMax = char.topRight.y}
        }
        
        let xCoord = xMin * previewView.frame.size.width
        let yCoord = (1 - yMax) * previewView.frame.size.height
        let width = (xMax - xMin) * previewView.frame.size.width
        let height = (yMax - yMin) * previewView.frame.size.height
        
        let layer = CALayer()
        layer.frame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.green.cgColor
        
        previewView.layer.addSublayer(layer)
    }
    
    func drawTextBox(box: VNRectangleObservation) {
        let xCoord = box.topLeft.x * previewView.frame.size.width
        let yCoord = (1 - box.topLeft.y) * previewView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * previewView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * previewView.frame.size.height
        
        let layer = CALayer()
        layer.frame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.blue.cgColor
        
        previewView.layer.addSublayer(layer)
    }
    
    
    // MARK: - Camera Delegate and Setup
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    func setupCamera() {
        previewView.session = session
        let availableCameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        var activeDevice: AVCaptureDevice?
        
        for device in availableCameraDevices.devices as [AVCaptureDevice]{
            if device.position == .back {
                activeDevice = device
                break
            }
        }
        
        do {
            let camInput = try AVCaptureDeviceInput(device: activeDevice!)
            
            if session.canAddInput(camInput) {
                session.addInput(camInput)
            }
        } catch {
            print("no camera")
        }
        session.sessionPreset = .high
        guard auth() else {return}
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "buffer queue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil))
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        previewView.videoPreviewLayer.videoGravity = .resize
        session.startRunning()
    }
    
    private func auth() -> Bool{
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                              completionHandler: { (granted:Bool) -> Void in
                                                if granted {
                                                    DispatchQueue.main.async {
                                                        self.previewView.setNeedsDisplay()
                                                    }
                                                }
                                              })
                return true
            case .authorized:
                return true
            case .denied, .restricted: return false
        }
    }
    
}

