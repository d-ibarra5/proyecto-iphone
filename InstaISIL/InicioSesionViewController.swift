//
//  InicioSesionViewController.swift
//  InstaISIL
//
//  Created by user178963 on 10/9/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit

class InicioSesionViewController: UIViewController {
    
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    func MensajeAlerta (titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true)
    }
    
    @IBAction func clickBtnCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
