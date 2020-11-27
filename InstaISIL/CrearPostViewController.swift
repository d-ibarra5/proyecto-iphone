//
//  CrearPostViewController.swift
//  InstaISIL
//
//  Created by user179030 on 11/26/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit
import Firebase

class CrearPostViewController: UIViewController {
    
    
    @IBOutlet weak var imgURL : UITextField!
    @IBOutlet weak var descripcion : UITextView!
        
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickGuardar(_ sender: Any) {
        
        //Conseguir datos
        guard let desc = self.descripcion.text, desc.count != 0 else {
            self.showAlertWithTitle("Error", message: "Debe ingresar un texto para su post", acceptButton: "Aceptar")
            return
        }
        let imagenURL = imgURL.text as? String ?? ""
        let user = UserDefaults.standard.string(forKey: "Usuario") as? String ?? ""
        
        //Conseguir fecha actual
        let now = Date()
        let fec = Timestamp(date: now)
        
        let db = Firestore.firestore()
        
        //Confirmar publicacion
        self.showAlertWithTitle("Confirmar publicacion", message: "¿Desea realizar esta publicacion?", acceptButton: "Publicar", cancelButton: "Cancelar", acceptHandler: {
            
            /*let objPost = PostBE(id: "",
                                 usuario: user,
                                 fecha: fec,
                                 imgURL: imagenURL,
                                 descripcion: desc)*/
            
            //Insertar en firebase
            db.collection("posts").addDocument(data: [
                "descripcion": desc,
                "fecha": fec,
                "imgURL": imagenURL,
                "usuario": user,
                "likes": [],
                "comentarios": []
            ]) { err in
                if let err = err {
                    print("Error agregando post: \(err)")
                } else {
                    //Mostrar mensaje
                    self.showAlertWithTitle("Hecho", message: "Su publicacion fue realizada, regrese al timeline para verla", acceptButton: "Aceptar") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Estilo
        let gris = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        descripcion.layer.borderColor = gris
        descripcion.layer.borderWidth = 1
        descripcion.layer.cornerRadius = 5
        
        imgURL.layer.borderColor = gris
        imgURL.layer.borderWidth = 1
        imgURL.layer.cornerRadius = 5
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
