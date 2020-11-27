//
//  PostTableViewCell.swift
//  InstaISIL
//
//  Created by user179030 on 11/26/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit


class PostTableViewCell : UITableViewCell {
    
    @IBOutlet weak private var username             : UILabel!
    @IBOutlet weak private var descripcion          : UILabel!
    @IBOutlet weak private var fecha                : UILabel!
    @IBOutlet weak private var fotoPerfil           : UIImageView!
    @IBOutlet weak private var imagen               : UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
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
    }
    
}
