//
//  CambiarPasswordViewController.swift
//  InstaISIL
//
//  Created by user179030 on 11/13/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit

class CambiarPasswordViewController: UIViewController {
    
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    @IBOutlet weak var txtPassword1: UITextField!
    @IBOutlet weak var txtPassword2: UITextField!
    
    var usuarioActual: String = ""
    
    func MensajeAlerta (titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true)
    }
    
    @IBAction func clickBtnModificarPassword(_ sender: Any) {
        
        //No permitir campos vacios
        guard let password1 = txtPassword1.text, !password1.isEmpty else {
            MensajeAlerta(titulo: "Ingrese el nuevo password", mensaje: "Debe insertar su nuevo password")
            return
        }
        guard let password2 = txtPassword2.text, !password2.isEmpty else {
            MensajeAlerta(titulo: "Ingrese el nuevo password", mensaje: "Debe insertar su nuevo password")
            return
        }
        
        let passwordCorrecto1 = password1.isValidPassword()
        let passwordCorrecto2 = password2.isValidPassword()
        
        if passwordCorrecto1 == false {
            MensajeAlerta(titulo: "Password no valido", mensaje: "Por favor solo ingresar letras, numeros o underscore. Ademas el password debe contener entre 7 y 18 caracteres.")
            return
        }
        if passwordCorrecto2 == false {
            MensajeAlerta(titulo: "Password no valido", mensaje: "Por favor solo ingresar letras, numeros o underscore. Ademas el password debe contener entre 7 y 18 caracteres.")
            return
        }
        
        if password1 != password2 {
            MensajeAlerta(titulo: "Los passwords no coinciden", mensaje: "Las contraseñas deben coincidir, intente nuevamente.")
            return
        }
        
        MensajeAlerta(titulo: "Cambio correcto!", mensaje: "Su contraseña ha sido cambiada.")
        
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
