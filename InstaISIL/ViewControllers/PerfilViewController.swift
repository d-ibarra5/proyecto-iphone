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
    
    public var objUsuario : UsuarioBE!
    
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
                
                self.objUsuario = UsuarioBE(
                    usuario: self.nombreUsuario,
                    nombres: nom,
                    apellidos: ape,
                    carrera: carrera,
                    sede: sede)
                
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
        actualizarSeguir()
    }
    
    @IBAction func seguir(_ sender: Any) {
        
        let user = UserDefaults.standard.string(forKey: "Usuario") as? String ?? ""
        
        let db = Firestore.firestore()
        let usuarioDoc = db.collection("usuarios").document(user)
        
        //Si ya lo siguio, dejar de seguir
        if btnSeguir.tag == 1 {
            //Guardar en firebase
            usuarioDoc.updateData([
                "seguidos": FieldValue.arrayRemove([nombreUsuario])
            ])
        }
        
        //Si no, seguir
        else if btnSeguir.tag == 0{
            //Guardar en firebase
            usuarioDoc.updateData([
                "seguidos": FieldValue.arrayUnion([nombreUsuario])
            ])
        }
        
        actualizarSeguir()
    }
    
    func actualizarSeguir(){        
        let user = UserDefaults.standard.string(forKey: "Usuario") as? String ?? ""
        
        let db = Firestore.firestore()
        let docRef = db.collection("usuarios").document(user)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var seg = [String]()
                if let seguidos = data!["seguidos"] {
                    seg = seguidos as? [String] ?? [String]()
                }
                
                if seg.contains(self.nombreUsuario){
                    self.btnSeguir.setTitle("No seguir", for: .normal)
                    self.btnSeguir.backgroundColor = UIColor.systemRed
                    self.btnSeguir.tag = 1
                }
                else{
                    self.btnSeguir.setTitle("Seguir", for: .normal)
                    self.btnSeguir.backgroundColor = UIColor.systemGreen
                    self.btnSeguir.tag = 0
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func btnEditarPerfil(_ sender: Any) {
        self.performSegue(withIdentifier: "EditarPerfilViewController", sender: objUsuario)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditarPerfilViewController {
            controller.objUsuario = sender as? UsuarioBE
        }
    }
    

}
