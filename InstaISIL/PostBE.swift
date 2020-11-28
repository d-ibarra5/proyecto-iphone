//
//  PostBE.swift
//  InstaISIL
//
//  Created by user179030 on 11/26/20.
//  Copyright © 2020 isil. All rights reserved.
//

import Foundation

class PostBE {
    
    var id              : String
    var usuario         : String
    var fecha           : Date
    var imgURL          : String
    var descripcion     : String
    
    var comentarios = [ComentarioBE]()
    var likes = [String]()
    
    init(id: String, usuario: String, fecha: Date, imgURL: String, descripcion: String, likes: [String], comentarios: [ComentarioBE]) {
        self.id = id
        self.usuario = usuario
        self.imgURL = imgURL
        self.descripcion = descripcion
        self.fecha = fecha
        self.likes = likes
        
        let coms = comentarios.sorted(by: { $0.fecha.compare($1.fecha) == .orderedDescending })
        self.comentarios = coms
    }
    
}

class ComentarioBE {
    var usuario     : String
    var fecha       : Date
    var contenido   : String
    
    init(usuario: String, fecha: Date, contenido: String){
        self.usuario = usuario
        self.fecha = fecha
        self.contenido = contenido
    }    
}
