//
//  Constants.swift
//  BeersApp
//
//  Created by Alexander Rivero on 17/09/2020.
//  Copyright © 2020 Alexander Rivero. All rights reserved.
//

import Foundation
import UIKit


class Utils {
    
    //MARK: CONSTANTS
    
    static let urlBase = "https://api.punkapi.com/v2/"
    
    
    //MARK: FUNCTIONS
    
    static func showAlert(title: String?, text: String?, view: UIViewController){
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        view.present(alert, animated: true)
    }
    
}

//MARK: STRUCTS

struct Beer {
    var name: String = ""
    var url_image: String = ""
    var description: String = ""
    var abv: Double = 0
}

//MARK: EXTENSIONS

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

