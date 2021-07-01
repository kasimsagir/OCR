//
//  NewMedicineVC.swift
//  OCRProject
//
//  Created by Kasım Sağır on 22.06.2021.
//

import UIKit
import PanModal
import SnapKit

protocol NewMedicineVCDelegate: class {
    func refresh()
    func missingText(medicine: UserMedicineDAO)
}

class NewMedicineVC: BaseVC, PanModalPresentable, UITextFieldDelegate {
    var panScrollable: UIScrollView?
    
    var topOffset: CGFloat = 0.0
    
    var shortFormHeight: PanModalHeight = .contentHeight(540)
    
    var longFormHeight: PanModalHeight = .contentHeight(540)
    
    var cornerRadius: CGFloat = 16
    
    var springDamping: CGFloat = 0.0
    
    var transitionDuration: Double = 0.0
    
    var transitionAnimationOptions: UIView.AnimationOptions = []
    
    var panModalBackgroundColor: UIColor = .clear
    
    var dragIndicatorBackgroundColor: UIColor = .clear
    
    var scrollIndicatorInsets: UIEdgeInsets = .zero
    
    var anchorModalToLongForm: Bool = true
    
    var allowsExtendedPanScrolling: Bool = false
    
    var allowsDragToDismiss: Bool = true
    
    var allowsTapToDismiss: Bool = true
    
    var isUserInteractionEnabled: Bool = true
    
    var isHapticFeedbackEnabled: Bool = true
    
    var shouldRoundTopCorners: Bool = true
    
    var showDragIndicator: Bool = false
    
    func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return true
    }
    
    func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) {
        
    }
    
    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return true
    }
    
    func shouldTransition(to state: PanModalPresentationController.PresentationState) -> Bool {
        return true
    }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        
    }
    
    func panModalWillDismiss() {
        
    }
    
    func panModalDidDismiss() {
        
    }
    
    weak var delegate: NewMedicineVCDelegate?
    
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
//        label.font = .medium18
        label.backgroundColor = .clear
        label.textColor = .white
        label.alpha = 0.7
        label.text = "Yeni İlaç Ekle"
        label.textAlignment = .center
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Uygula", for: .normal)
//        button.titleLabel?.font = .bold18
        button.backgroundColor = .melon
        button.titleLabel?.textColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
        return button
    }()
    
    var newMedicine: UserMedicineDAO = UserMedicineDAO(_id: "local", isCanUse: true, medicineDAO: MedicineDAO(brand: "", _description: "", gramaj: "", _id: "local1", name: "", photoPath: "", skt: "-"), repeatDaily: 0, repeatDay: 0, used: 0, userId: "me")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        self.view.backgroundColor = .lightdark
        stackView.addArrangedSubview(getTextField(id: 1, title: "İlaç adı", placeholder: "Ad"))
        stackView.addArrangedSubview(getTextField(id: 2, title: "İlaç marka adı", placeholder: "Marka"))
        stackView.addArrangedSubview(getTextField(id: 3, title: "İlaç açıklama", placeholder: "Açıklama"))
        stackView.addArrangedSubview(getTextField(id: 4, title: "İlaç gramaj bilgisi", placeholder: "Mg"))
        stackView.addArrangedSubview(getTextField(id: 5, title: "Kaç günde bir", placeholder: "Gün"))
        stackView.addArrangedSubview(getTextField(id: 6, title: "Günde kaç defa", placeholder: "Adet"))
        
        containerView.addSubviews([titleLabel, stackView, applyButton])
        self.view.addSubview(containerView)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        applyButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.height.equalTo(48)
        }
    }
    
    @objc func closeAction(){
        dismiss(animated: true)
    }
    
    @objc func applyAction(){
        if newMedicine.medicineDAO.name != "" &&
            newMedicine.medicineDAO.brand != "" &&
            newMedicine.medicineDAO._description != "" &&
            newMedicine.medicineDAO.gramaj != "" &&
            newMedicine.repeatDay != 0 &&
            newMedicine.repeatDaily != 0 {
            MedicineManager.shared.saveObject(object: newMedicine)
            delegate?.refresh()
            dismiss(animated: true)
        }else {
            dismiss(animated: true)
            delegate?.missingText(medicine: newMedicine)
        }
    }
    
    func getTextField(id: Int, title: String, placeholder: String)-> UIView{
        let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            //        label.font = .medium18
            label.backgroundColor = .clear
            label.textColor = .white
            label.alpha = 0.7
            label.text = title
            return label
        }()
        
        let textField: UITextField = {
            let textField = UITextField()
            textField.placeholder = placeholder
            textField.tag = id
            textField.textColor = .white
            textField.delegate = self
            textField.text = getText(tag: id)
            return textField
        }()
        
        containerView.addSubviews([titleLabel, textField])
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        return containerView
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
            case 1:
                newMedicine.medicineDAO.name = textField.text
            case 2:
                newMedicine.medicineDAO.brand = textField.text ?? ""
            case 3:
                newMedicine.medicineDAO._description = textField.text ?? ""
            case 4:
                newMedicine.medicineDAO.gramaj = textField.text ?? ""
            case 5:
                newMedicine.repeatDay = Int(textField.text ?? "") ?? 0
            case 6:
                newMedicine.repeatDaily = Int(textField.text ?? "") ?? 0
            default:
                break
        }
    }
    
    func getText(tag: Int)->String{
        switch tag {
            case 1:
                return newMedicine.medicineDAO.name ?? ""
            case 2:
                return  newMedicine.medicineDAO.brand
            case 3:
                return  newMedicine.medicineDAO._description
            case 4:
                return  newMedicine.medicineDAO.gramaj
            case 5:
                return  String(newMedicine.repeatDay)
            case 6:
                return  String(newMedicine.repeatDaily)
            default:
                return ""
        }
    }
}

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
