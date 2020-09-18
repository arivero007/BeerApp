//
//  BeerViewController.swift
//  BeersApp
//
//  Created by Alexander Rivero on 18/09/2020.
//  Copyright © 2020 Alexander Rivero. All rights reserved.
//

import UIKit

class BeerViewController: UIViewController{
    
    var beer: Beer?
    
    //MARK: UI References
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerDescription: UITextView!
    @IBOutlet weak var beerABV: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Load beer data
        loadData()
    }
    
    func loadData(){
        
        if beer != nil {
            beerName.text = beer?.name
            beerDescription.text = beer?.description
            beerImage.load(url: URL.init(string: beer!.url_image)!)
            beerABV.text = NSLocalizedString("ABV", comment: "degrees of alcohol") + (beer?.abv.description)!
        }
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
