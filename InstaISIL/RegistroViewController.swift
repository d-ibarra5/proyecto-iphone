//
//  RegistroViewController.swift
//  InstaISIL
//
//  Created by user178963 on 10/7/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit
import Firebase

extension RegistroViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.txtFecha == textField {
            self.performSegue(withIdentifier: "DatePickerViewController", sender: nil)
            return false  
        }
        else if self.txtSede == textField {
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

extension RegistroViewController: DatePickerViewControllerDelegate {
    func datePickerViewController(_ controller: DatePickerViewController, didDateSelect date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd 'de' MMMM 'del' yyyy"
        dateFormatter.locale = Locale(identifier: "es_PE")
        self.txtFecha.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.fechaFormateada = dateFormatter.string(from: date)
    }
}

extension RegistroViewController: PickerViewControllerDelegate {
    
    func pickerViewController(_ controller: PickerViewController, didSelectItem item: String) {
         if pickerActual == "Sede" {
            self.txtSede.text = item
        }
        else if pickerActual == "Carrera" {
            self.txtCarrera.text = item
        }
    }
    
}

class RegistroViewController: UIViewController {
        
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtSede: UITextField!
    @IBOutlet weak var txtCarrera: UITextField!
    @IBOutlet weak var txtFecha: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    
    var fechaFormateada = ""
    var pickerActual: String = ""
    
    let sedes = ["Jesus Maria", "Miraflores", "La Molina", "San Isidro"]
    
    let carreras = ["Diseno Grafico","Periodismo","Marketing","Desarrollo de Software","Hoteleria"]
    
    func MensajeAlerta (titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true)
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
            MensajeAlerta(titulo: "Nombre vacio", mensaje: "Debe insertar sus nombres")
            return
        }
        guard let apellidos = txtApellidos.text, !apellidos.isEmpty else {
            MensajeAlerta(titulo: "Apellido vacio", mensaje: "Debe insertar sus apellidos")
            return
        }
        guard let email = txtEmail.text, !email.isEmpty else {
            MensajeAlerta(titulo: "Email vacio", mensaje: "Debe insertar su email")
            return
        }
        guard let usuario = txtUsuario.text, !usuario.isEmpty else {
            MensajeAlerta(titulo: "Usuario vacio", mensaje: "Debe insertar su nombre de usuario")
            return
        }
        guard let password = txtPassword.text, !password.isEmpty else {
            MensajeAlerta(titulo: "Password vacio", mensaje: "Debe insertar su password")
            return
        }
        guard let sede = txtSede.text, !sede.isEmpty else {
            MensajeAlerta(titulo: "Sede vacia", mensaje: "Debe elegir su sede")
            return
        }
        guard let carrera = txtCarrera.text, !carrera.isEmpty else {
            MensajeAlerta(titulo: "Carrera vacia", mensaje: "Debe elegir su carrera")
            return
        }
        guard let fecha = txtFecha.text, !fecha.isEmpty else {
            MensajeAlerta(titulo: "Fecha de nacimiento vacia", mensaje: "Debe elegir su fecha de nacimiento")
            return
        }
                
        //Validar caracteres con regex
        let usuarioCorrecto = ValidarConRegex(patron: "^[0-9a-zA-Z\\_]{7,18}$", str: usuario)
        let passwordCorrecto = password.isValidPassword()
        let nombreIncorrecto = ValidarConRegex(patron: ".*[^A-Za-z ].*", str: nombres)
        let apellidoIncorrecto = ValidarConRegex(patron: ".*[^A-Za-z ].*", str: apellidos)
        let emailCorrecto = email.isValidEmail()
        
        if nombreIncorrecto == true {
            MensajeAlerta(titulo: "Nombres no validos", mensaje: "Por favor solo ingresar letras en el nombre")
            return
        }
        
        if apellidoIncorrecto == true {
            MensajeAlerta(titulo: "Apellidos no validos", mensaje: "Por favor solo ingresar letras en el apellido")
            return
        }
        
        if emailCorrecto == false {
            MensajeAlerta(titulo: "Email no valido", mensaje: "Por favor ingrese un correo valido.")
            return
        }
        
        if usuarioCorrecto == false {
            MensajeAlerta(titulo: "Usuario no valido", mensaje: "Por favor solo ingresar letras, numeros o underscore. Ademas el usuario debe contener entre 7 y 18 caracteres.")
            return
        }
        if passwordCorrecto == false {
            MensajeAlerta(titulo: "Password no valido", mensaje: "Por favor solo ingresar letras, numeros o underscore. Ademas el password debe contener entre 7 y 18 caracteres.")
            return
        }
        
        //Si todo salio bien, registrar en Firebase
        
        let db = Firestore.firestore()
        
        //Si el usuario ya existe, retornar
        let docRef = db.collection("usuarios").document(usuario)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.MensajeAlerta(titulo: "Usuario ya existe", mensaje: "El usuario ingresado ya existe, intente utilizar otro nombre de usuario.")
                return
            }
            else{
                //Registrar datos
                db.collection("usuarios").document(usuario).setData([
                    "nombres": nombres,
                    "apellidos": apellidos,
                    "password": password,
                    "sede": sede,
                    "carrera": carrera,
                    "fecha": self.fechaFormateada,
                    "email": email
                ]) { err in
                    if let err = err {
                        print("Error agregando usuario: \(err)")
                    } else {
                        print("Usuario fue agregado con ID: \(usuario)")
                    }
                }
                /*
                MensajeAlerta(titulo: "Usuario registrado correctamente!", mensaje: "Bienvenido, \(usuario)! (\(nombres) \(apellidos)) \n" +
                "Carrera: \(carrera) \n" +
                "Sede: \(sede) \n" +
                    "Fecha de nacimiento: \(fecha)")*/
                
                self.performSegue(withIdentifier: "HomeViewController", sender: nil)
            }
        }
    }
    
    
    @IBAction func clickBtnCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? DatePickerViewController {
            controller.delegate =  self
        }
        else if let controller = segue.destination as? PickerViewController {
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
