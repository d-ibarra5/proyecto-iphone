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
                
        let db = Firestore.firestore()
                
        //Conseguir todos los posts
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let usu = data["usuario"] as? String ?? ""
                    let fch = data["fecha"] as? String ?? ""
                    let img = data["imgURL"] as? String ?? ""
                    let dsc = data["descripcion"] as? String ?? ""
                    
                    let post = PostBE(id: document.documentID, usuario: usu, fecha: fch, imgURL: img, descripcion: dsc)
                    self.arrayPosts.append(post)
                    print("\(document.documentID) => \(document.data())")
                }
                self.tabla.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        return cell
    }

}
