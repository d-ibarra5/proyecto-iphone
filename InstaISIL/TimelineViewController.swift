//
//  TimelineViewController.swift
//  InstaISIL
//
//  Created by user179030 on 11/26/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit
import Firebase

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tabla: UITableView!
    
    var arrayPosts = [PostBE]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cargarPosts()
    }
    
    func cargarPosts(){
        //Limpiar array
        arrayPosts = [PostBE]()
        
        let db = Firestore.firestore()
                
        //Conseguir todos los posts
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let usu = data["usuario"] as? String ?? ""
                    let img = data["imgURL"] as? String ?? ""
                    let dsc = data["descripcion"] as? String ?? ""
                    let ts = data["fecha"] as! Timestamp
                    let fch = ts.dateValue()
                    
                    //Conseguir likes
                    var lks = [String]()
                    
                    if let likes = data["likes"] {
                        lks = likes as? [String] ?? [String]()
                    }
                    
                    //Conseguir comentarios
                    var comments = [ComentarioBE]()
                    if let coms = data["comentarios"]{
                        let commentArray = data["comentarios"]! as! [Any]
                        
                        for comment in commentArray {
                            let value = comment as! [String: Any]
                            
                            let tsComment = value["fecha"] as! Timestamp
                            let fechaComment = tsComment.dateValue()
                            let usuComment = value["usuario"] as? String ?? ""
                            let contComment = value["contenido"] as? String ?? ""
                            
                            let comentario = ComentarioBE(usuario: usuComment, fecha: fechaComment, contenido: contComment)
                            comments.append(comentario)
                            print(comentario)
                        }
                    }                    
                    
                    //Guardar post
                    let post = PostBE(id: document.documentID, usuario: usu, fecha: fch, imgURL: img, descripcion: dsc, likes: lks, comentarios: comments)
                    self.arrayPosts.append(post)
                    //print("\(document.documentID) => \(document.data())")
                }
                
                //Ordenar posts (mas reciente primero)
                self.arrayPosts = self.arrayPosts.sorted(by: { $0.fecha.compare($1.fecha) == .orderedDescending })
                
                //Recargar tabla
                self.tabla.reloadData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ComentariosViewController {
            controller.objPost = sender as? PostBE
        }
    }
}

extension TimelineViewController: PostTableViewCellDelegate {
    func postTableViewCell(_ cell: PostTableViewCell) {
        self.performSegue(withIdentifier: "ComentariosViewController", sender: cell.objPost)
    }
}

extension TimelineViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PostTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        cell.objPost = self.arrayPosts[indexPath.row]
        cell.delegate = self
        return cell
    }

}
