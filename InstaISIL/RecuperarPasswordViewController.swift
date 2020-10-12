//
//  RecuperarPasswordViewController.swift
//  InstaISIL
//
//  Created by user178963 on 10/9/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit

class RecuperarPasswordViewController: UIViewController {
  
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
      
     
    @IBAction func btnConfirmar(_ sender: Any) {
        
        //No permitir campos vacios
        guard let email = txtEmail.text, !email.isEmpty else {
            MensajeAlerta(titulo: "Inserte email", mensaje: "Debe insertar su email")
            return
        }
        
        //Validar caracteres con regex
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let emailCorrecto = emailPred.evaluate(with: email)
        
        if emailCorrecto == false {
            MensajeAlerta(titulo: "Email no valido", mensaje: "Por favor ingrese un correo valido.")
            return
        }
        
        //Si todo salio bien
        MensajeAlerta(titulo: "Mensaje enviado!", mensaje: "Se ha enviado un mensaje con el link de recuperacion de password a \(email)")
                     
    }
    
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
