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
        
    public var objPost: PostBE!{
        didSet{
            self.actualizar()
        }
    }
    
    private func actualizar() {            
        self.username.text       = self.objPost.usuario
        self.descripcion.text    = self.objPost.descripcion
        self.fecha.text = self.objPost.fecha.formatearFecha()
    }
    
}
