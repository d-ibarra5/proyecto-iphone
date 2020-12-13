//
//  EditarPerfilViewController.swift
//  InstaISIL
//
//  Created by user179030 on 12/11/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit
import Firebase

class EditarPerfilViewController: UIViewController {
    
    public var objUsuario : UsuarioBE!
    
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtSede: UITextField!
    @IBOutlet weak var txtCarrera: UITextField!
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    var pickerActual: String = ""
    let sedes = ["Jesus Maria", "Miraflores", "La Molina", "San Isidro"]
    let carreras = ["Diseno Grafico","Periodismo","Marketing","Desarrollo de Software","Hoteleria"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objUsuario.recargarDatos()
        ActualizarDatos()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.objUsuario.recargarDatos()
        ActualizarDatos()
    }    
    
    func ActualizarDatos(){
        txtNombres.text = objUsuario.nombres
        txtApellidos.text = objUsuario.apellidos
        txtSede.text = objUsuario.sede
        txtCarrera.text = objUsuario.carrera        
    }
    
    func ValidarConRegex(patron: String, str: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: patron, options: .caseInsensitive)
            if regex.matches(in: str, options: [], range: NSMakeRange(0, str.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
    
    @IBAction func clickBtnRegistrar(_ sender: Any) {
        
        //No permitir campos vacios
        guard let nombres = txtNombres.text, !nombres.isEmpty else {
            self.showAlertWithTitle("Nombre vacio", message: "Debe insertar un nombre", acceptButton: "Aceptar")
            return
        }
        guard let apellidos = txtApellidos.text, !apellidos.isEmpty else {
            self.showAlertWithTitle("Apellido vacio", message: "Debe insertar un apellido", acceptButton: "Aceptar")
            return
        }
        guard let sede = txtSede.text, !sede.isEmpty else {
            self.showAlertWithTitle("Sede vacia", message: "Debe elegir su sede", acceptButton: "Aceptar")
            return
        }
        guard let carrera = txtCarrera.text, !carrera.isEmpty else {
            self.showAlertWithTitle("Carrera vacia", message: "Debe elegir su carrera", acceptButton: "Aceptar")
            return
        }
                
        //Validar caracteres con regex
        let nombreIncorrecto = ValidarConRegex(patron: ".*[^A-Za-z ].*", str: nombres)
        let apellidoIncorrecto = ValidarConRegex(patron: ".*[^A-Za-z ].*", str: apellidos)
        
        if nombreIncorrecto == true {
            self.showAlertWithTitle("Nombres no validos", message: "Por favor solo ingresar letras en el nombre", acceptButton: "Aceptar")
            return
        }
        
        if apellidoIncorrecto == true {
            self.showAlertWithTitle("Apellidos no validos", message: "Por favor solo ingresar letras en el apellido", acceptButton: "Aceptar")
            return
        }
                
        //Si todo salio bien, registrar en Firebase
        
        let db = Firestore.firestore()
                    
        //Registrar datos
        db.collection("usuarios").document(self.objUsuario.usuario).setData([
            "nombres": nombres,
            "apellidos": apellidos,
            "sede": sede,
            "carrera": carrera
        ], merge: true) { err in
            if let err = err {
                print("Error agregando usuario: \(err)")
            } else {
                print("Usuario fue actualizado: \(self.objUsuario.usuario)")
            }
        }
        
        self.showAlertWithTitle("Perfil actualizado!", message: "Sus datos han sido actualizados", acceptButton: "Aceptar") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func clickBtnCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? PickerViewController {
            controller.delegate = self

            if pickerActual == "Sede" {
                controller.arrayItems = sedes
            }
            else if pickerActual == "Carrera" {
                controller.arrayItems = carreras
            }
        }
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

extension EditarPerfilViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.txtSede == textField {
            pickerActual = "Sede"
            self.performSegue(withIdentifier: "PickerViewController", sender: nil)
            return false
        }
        else if self.txtCarrera == textField {
            pickerActual = "Carrera"
            self.performSegue(withIdentifier: "PickerViewController", sender: nil)
            return false
        }
        return true
    }
}

extension EditarPerfilViewController: PickerViewControllerDelegate {
    
    func pickerViewController(_ controller: PickerViewController, didSelectItem item: String) {
         if pickerActual == "Sede" {
            self.txtSede.text = item
        }
        else if pickerActual == "Carrera" {
            self.txtCarrera.text = item
        }
    }
    
}
