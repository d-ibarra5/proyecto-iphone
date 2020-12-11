//
//  AlertManager.swift
//  InstaISIL
//
//  Created by user179030 on 11/26/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit

extension UIViewController {
    
    typealias AlertHandlerOption = ()->Void
    
    func showAlertWithTitle(_ title: String, message: String, acceptButton: String, handler: AlertHandlerOption? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: acceptButton, style: .default) { (_) in
            handler?()
        }
        
        alertController.addAction(acceptAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithTitle(_ title: String, message: String, acceptButton: String, cancelButton: String, acceptHandler: AlertHandlerOption? = nil, cancelHandler: AlertHandlerOption? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: acceptButton, style: .default) { (_) in
            acceptHandler?()
        }
        
        let cancelAction = UIAlertAction(title: cancelButton, style: .destructive) { (_) in
            cancelHandler?()
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
