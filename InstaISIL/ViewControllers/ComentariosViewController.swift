//
//  ComentariosViewController.swift
//  InstaISIL
//
//  Created by user179030 on 11/28/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit
import Firebase

class ComentariosViewController: UIViewController {
    
    @IBOutlet weak var comentario : UITextView!
    @IBOutlet weak var tabla: UITableView!
    public var objPost : PostBE!
    
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func clickComentar(_ sender: Any) {
        
        //Validar datos
        guard let com = self.comentario.text, com.count != 0 else {
            self.showAlertWithTitle("Error", message: "Debe escribir un comentario primero", acceptButton: "Aceptar")
            return
        }
        
        let user = UserDefaults.standard.string(forKey: "Usuario") as? String ?? ""
        let db = Firestore.firestore()
        let postDoc = db.collection("posts").document(objPost.id)
        let fecha = Date()
        
        //Guardar en firebase
        postDoc.updateData([
            "comentarios": FieldValue.arrayUnion([[
                "usuario": user,
                "fecha": fecha,
                "contenido": com
            ]])
        ])
        
        objPost.comentarios.append(ComentarioBE(usuario: user, fecha: fecha, contenido: com))
        
        //Ordenar posts (mas reciente primero)
        objPost.comentarios = objPost.comentarios.sorted(by: { $0.fecha.compare($1.fecha) == .orderedDescending })
        
        self.comentario.text = ""
        
        self.tabla.reloadData()
                
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        //Estilo
        let gris = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        comentario.layer.borderColor = gris
        comentario.layer.borderWidth = 1
        comentario.layer.cornerRadius = 5
    }    
    
}

extension ComentariosViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objPost.comentarios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ComentarioTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ComentarioTableViewCell
        cell.objComentario = self.objPost.comentarios[indexPath.row]
        return cell
    }

}
