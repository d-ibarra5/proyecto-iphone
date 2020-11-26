//
//  CrearPostViewController.swift
//  InstaISIL
//
//  Created by user179030 on 11/26/20.
//  Copyright © 2020 isil. All rights reserved.
//

import UIKit

protocol CrearPostViewControllerDelegate {
    func crearPostViewController(_ controller: CrearPostViewController, didCreatePost post: PostBE)
}

class CrearPostViewController: UIViewController {
    
    
    @IBOutlet weak var imgURL : UITextField!
    @IBOutlet weak var descripcion : UITextView!
    
    
    var delegate: CrearPostViewControllerDelegate?
    
    func MensajeAlerta (titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true)
    }
    
    @IBAction func clickGuardar(_ sender: Any) {
        guard let desc = self.descripcion.text, desc.count != 0 else {
            self.showAlertWithTitle("Error", message: "Debe ingresar un texto para su post", acceptButton: "Aceptar")
            return
        }
        
        let imagenURL = imgURL.text as? String ?? ""
        let user = UserDefaults.standard.string(forKey: "Usuario") as? String ?? ""
        
        self.showAlertWithTitle("Confirmar publicacion", message: "¿Desea realizar esta publicacion?", acceptButton: "Publicar", cancelButton: "Cancelar", acceptHandler: {
            let objPost = PostBE(id: "",
                                 usuario: user,
                                 fecha: Date().formatearFecha(),
                                 imgURL: imagenURL,
                                 descripcion: desc)
            self.delegate?.crearPostViewController(self, didCreatePost: objPost)
            self.navigationController?.popViewController(animated: true)
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
