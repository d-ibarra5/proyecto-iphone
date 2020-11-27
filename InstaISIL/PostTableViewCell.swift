//
//  PostTableViewCell.swift
//  InstaISIL
//
//  Created by user179030 on 11/26/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell : UITableViewCell {
    
    @IBOutlet weak private var username             : UILabel!
    @IBOutlet weak private var descripcion          : UILabel!
    @IBOutlet weak private var fecha                : UILabel!
    @IBOutlet weak private var fotoPerfil           : UIImageView!
    @IBOutlet weak private var imagen               : UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    @IBOutlet weak private var btnLike              : UIButton!
    @IBOutlet weak private var btnComentarios       : UIButton!
    @IBOutlet weak private var btnVerLikes          : UIButton!
        
    @IBAction func likePost(_ sender: Any) {
        
        let user = UserDefaults.standard.string(forKey: "Usuario") as? String ?? ""
        let db = Firestore.firestore()
        let postDoc = db.collection("posts").document(objPost.id)
        
        //Si ya le dio like, removerlo
        if btnLike.tag == 1{
            objPost.likes = objPost.likes.filter {$0 != user}
            
            //Guardar en firebase
            postDoc.updateData([
                "likes": FieldValue.arrayRemove([user])
            ])
        }
        
        //Si no, agregarlo
        else if btnLike.tag == 0{
            objPost.likes.append(user)
            
            //Guardar en firebase
            postDoc.updateData([
                "likes": FieldValue.arrayUnion([user])
            ])
        }
        
        //Actualizar graficos
        actualizarLikes()
    }
    
    @IBAction func verComentarios(_ sender: Any) {
        
    }
    
    public var objPost: PostBE!{
        didSet{
            self.actualizar()
        }
    }
    
    private func actualizar() {            
        self.username.text       = self.objPost.usuario
        self.descripcion.text    = self.objPost.descripcion
        self.fecha.text = self.objPost.fecha.formatearFecha()
        
        //Si hay imagen, descargarla
        if objPost.imgURL != "" {
            imageHeight.constant = 200
            let placeholderImage = UIImage(named: "placeholder")
            self.imagen.downloadImageInURLString(self.objPost.imgURL, placeHolderImage: placeholderImage) { (image, urlString) in
                if self.objPost.imgURL == urlString {
                    self.imagen.image = image
                }
            }
        }
        //Si no, ocultar view de imagen
        else {
            imageHeight.constant = 0
        }
        
        actualizarLikes()
    }
    
    private func actualizarLikes(){
        
        //Ver si usuario actual le dio like a este post
        let user = UserDefaults.standard.string(forKey: "Usuario") as? String ?? ""
        
        if objPost.likes.contains(user){
            btnLike.setImage(UIImage(named: "like2"), for: .normal)
            btnLike.tag = 1
        }
        else{
            btnLike.setImage(UIImage(named: "like1"), for: .normal)
            btnLike.tag = 0
        }
        
        //Setear texto de likes
        var likeText = "\(objPost.likes.count) likes"
        
        if objPost.likes.count == 1 {
            likeText = "\(objPost.likes.count) like"
        }
        
        //Setear cantidad de likes y comentarios
        btnVerLikes.setTitle(likeText, for: .normal)
    }
    
}
