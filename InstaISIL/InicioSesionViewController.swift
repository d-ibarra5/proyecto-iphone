//
//  InicioSesionViewController.swift
//  InstaISIL
//
//  Created by user178963 on 10/9/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit
import Firebase

class InicioSesionViewController: UIViewController {
    
    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    @IBAction func btnIniciarSesion(_ sender: Any) {
        //No permitir campos vacios
        guard let usuario = txtUsuario.text, !usuario.isEmpty else {
            MensajeAlerta(titulo: "Usuario vacio", mensaje: "Debe insertar su nombre de usuario")
            return
        }
        guard let password = txtPassword.text, !password.isEmpty else {
            MensajeAlerta(titulo: "Password vacio", mensaje: "Debe insertar su password")
            return
        }
        
        let db = Firestore.firestore()
        
        //Comprobar si usuario existe
        let docRef = db.collection("usuarios").document(usuario)

        docRef.getDocument { (document, error) in
            //Si existe, comprobar si password es correcto
            if let document = document, document.exists {
                let data = document.data()
                let realPassword = data?["password"] as? String ?? "0"
                
                //Enviar a home si contrasena es correcta
                if realPassword == password {
                    UserDefaults.standard.set(usuario, forKey: "Usuario")
                    
                    self.showAlertWithTitle("Correcto", message: "Bienvenido de nuevo, \(usuario)!", acceptButton: "Aceptar") {
                        self.performSegue(withIdentifier: "HomeViewController", sender: nil)
                    }
                }
                
                //Mostrar error si contrasena es incorrecta
                else{
                    self.MensajeAlerta(titulo: "Contraseña incorrecta", mensaje: "La contraseña ingresada no es la correcta.")
                    return
                }

            }
            //Si usuario no existe, dar mensaje de error
            else {
                self.MensajeAlerta(titulo: "Usuario no existe", mensaje: "El usuario ingresado no existe, ingrese un usuario correcto.")
                return
            }
        }
        
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
