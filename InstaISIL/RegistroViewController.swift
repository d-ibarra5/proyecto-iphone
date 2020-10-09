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
    
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
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
        guard let usuario = txtUsuario.text, !usuario.isEmpty else {
            MensajeAlerta(titulo: "Usuario vacio", mensaje: "Debe insertar su nombre de usuario")
            return
        }
        guard let password = txtPassword.text, !password.isEmpty else {
            MensajeAlerta(titulo: "Password vacio", mensaje: "Debe insertar su password")
            return
        }
                
        //Validar caracteres con regex
        let usuarioCorrecto = ValidarConRegex(patron: "^[0-9a-zA-Z\\_]{7,18}$", str: usuario)
        let passwordCorrecto = ValidarConRegex(patron: "^[0-9a-zA-Z\\_]{7,18}$", str: password)
        let nombreIncorrecto = ValidarConRegex(patron: ".*[^A-Za-z ].*", str: nombres)
        let apellidoIncorrecto = ValidarConRegex(patron: ".*[^A-Za-z ].*", str: apellidos)
        
        
        if nombreIncorrecto == true {
            MensajeAlerta(titulo: "Nombres no validos", mensaje: "Por favor solo ingresar letras en el nombre")
            return
        }
        
        if apellidoIncorrecto == true {
            MensajeAlerta(titulo: "Apellidos no validos", mensaje: "Por favor solo ingresar letras en el apellido")
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
        
        //Si todo salio bien
        MensajeAlerta(titulo: "Usuario registrado correctamente!", mensaje: "Bienvenido, \(usuario)! (\(nombres) \(apellidos)) \n" +
        "Carrera: \(carreras[pickerCarrera.selectedRow(inComponent: 0)]) \n" +
        "Sede: \(sedes[pickerSede.selectedRow(inComponent: 0)])")
                
    }
    
    
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
