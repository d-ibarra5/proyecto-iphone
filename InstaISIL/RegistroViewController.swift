//
//  RegistroViewController.swift
//  InstaISIL
//
//  Created by user178963 on 10/7/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var pickerCarrera: UIPickerView!
    
    @IBOutlet weak var pickerSede: UIPickerView!
    
    
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    let sedes = ["Jesus Maria", "Miraflores", "La Molina", "San Isidro"]
    
    let carreras = ["Diseno Grafico","Periodismo","Marketing","Desarrollo de Software","Hoteleria"]
    
    @IBAction func clickBtnCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerCarrera.dataSource = self
        pickerCarrera.delegate = self
        pickerSede.dataSource = self
        pickerSede.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            
            self.constraintBottomScroll.constant = keyboardFrame.height + 35
            self.view.layoutIfNeeded()
        }
    
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
   
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            
            self.constraintBottomScroll.constant = 35
            self.view.layoutIfNeeded()
        }
    }

}

extension RegistroViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerCarrera {
            return carreras.count
        }
        else if pickerView == pickerSede {
            return sedes.count
        }
        return 1
    }
    
    
}


extension RegistroViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerCarrera {
            return carreras[row]
        }
        else if pickerView == pickerSede {
            return sedes[row]
        }
        return "Ninguno"
    }
}
