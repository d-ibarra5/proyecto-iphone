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
    
    init(id: String, usuario: String, fecha: String, imgURL: String, descripcion: String) {
        self.id = id
        self.usuario = usuario
        self.imgURL = imgURL
        self.descripcion = descripcion
                
        //Formatear fecha
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from:fecha)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        self.fecha = calendar.date(from:components)!        
    }
    
}
