//
//  StringEmail.swift
//  InstaISIL
//
//  Created by user179030 on 11/13/20.
//  Copyright © 2020 isil. All rights reserved.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
                
        //Validar caracteres con regex
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let emailCorrecto = emailPred.evaluate(with: self)
        
        return emailCorrecto
        
    }
    
    func isValidPassword() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z\\_]{7,18}$", options: .caseInsensitive)
            if regex.matches(in: self, options: [], range: NSMakeRange(0, self.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
    
    
}
