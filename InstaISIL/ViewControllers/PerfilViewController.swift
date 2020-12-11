//
//  PerfilViewController.swift
//  InstaISIL
//
//  Created by user179030 on 12/11/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit
import Firebase

class PerfilViewController: UIViewController {
    
    @IBOutlet weak var btnSeguir : UIButton!
    @IBOutlet weak var btnPublicar : UIButton!
    @IBOutlet weak var btnEditarPerfil : UIButton!
    @IBOutlet weak var tituloPerfil : UILabel!
    @IBOutlet weak var usuario : UILabel!
    @IBOutlet weak var nombre : UILabel!
    @IBOutlet weak var sede : UILabel!
    @IBOutlet weak var carrera : UILabel!
    public var nombreUsuario : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        //Cargar datos de perfil
        let docRef = db.collection("usuarios").document(nombreUsuario)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let nom = data?["nombres"] as? String ?? ""
                let ape = data?["apellidos"] as? String ?? ""
                let sede = data?["sede"] as? String ?? ""
                let carrera = data?["carrera"] as? String ?? ""
                
                self.usuario.text = self.nombreUsuario
                self.nombre.text = nom + " " + ape
                self.sede.text = sede
                self.carrera.text = carrera
                
            } else {
                print("Usuario no existe")
            }
        }
        
        //Ocultar botones segun tipo de perfil
        let usuarioLogeado = UserDefaults.standard.string(forKey: "Usuario") as? String ?? ""
        if nombreUsuario == usuarioLogeado {
            btnSeguir.isHidden = true
            btnPublicar.isHidden = false
            btnEditarPerfil.isHidden = false
            tituloPerfil.text = "-Mi perfil-"
        }
        else{
            btnSeguir.isHidden = false
            btnPublicar.isHidden = true
            btnEditarPerfil.isHidden = true
            tituloPerfil.text = "-Perfil-"
        }
        
    }
    

}
