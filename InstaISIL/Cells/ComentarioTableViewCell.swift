//
//  ComentarioTableViewCell.swift
//  InstaISIL
//
//  Created by user179030 on 11/28/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit

class ComentarioTableViewCell : UITableViewCell {
    
    @IBOutlet weak private var username             : UILabel!
    @IBOutlet weak private var contenido            : UILabel!
    @IBOutlet weak private var fecha                : UILabel!
    
    public var objComentario: ComentarioBE!{
        didSet{
            self.actualizar()
        }
    }
    
    private func actualizar() {
        self.username.text       = self.objComentario.usuario
        self.contenido.text    = self.objComentario.contenido
        self.fecha.text = self.objComentario.fecha.formatearFecha()
    }
        
}
