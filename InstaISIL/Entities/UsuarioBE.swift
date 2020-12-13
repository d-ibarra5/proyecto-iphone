//
//  UsuarioBE.swift
//  InstaISIL
//
//  Created by user179030 on 12/13/20.
//  Copyright © 2020 isil. All rights reserved.
//

import Foundation
import Firebase

class UsuarioBE {
    var usuario     : String
    var nombres     : String
    var apellidos    : String
    var carrera     : String
    var sede     : String
    
    init(usuario: String, nombres: String, apellidos: String, carrera: String, sede: String){
        self.usuario = usuario
        self.nombres = nombres
        self.apellidos = apellidos
        self.carrera = carrera
        self.sede = sede
    }
    
    func recargarDatos(){
        let db = Firestore.firestore()
        
        //Cargar datos de perfil
        let docRef = db.collection("usuarios").document(usuario)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let nom = data?["nombres"] as? String ?? ""
                let ape = data?["apellidos"] as? String ?? ""
                let sede = data?["sede"] as? String ?? ""
                let carrera = data?["carrera"] as? String ?? ""
                
                self.nombres = nom
                self.apellidos = ape
                self.sede = sede
                self.carrera = carrera
                                
            } else {
                print("Usuario no existe")
            }
        }
    }
}
