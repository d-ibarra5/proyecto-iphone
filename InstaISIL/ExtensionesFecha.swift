//
//  ExtensionesFecha.swift
//  InstaISIL
//
//  Created by user179030 on 11/26/20.
//  Copyright © 2020 isil. All rights reserved.
//

import Foundation

extension Date {
    
    func formatearFecha() -> String {        
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let texto = df.string(from: self)
        return texto
    }
}
