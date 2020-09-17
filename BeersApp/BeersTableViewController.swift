//
//  BeersTableViewController.swift
//  BeersApp
//
//  Created by Alexander Rivero on 17/09/2020.
//  Copyright © 2020 Alexander Rivero. All rights reserved.
//

import UIKit

class BeersTableViewController: UITableViewController, WSDelegate {
    
    let ws: WebService = WebService()
    var beers = [Beer]()

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ws.delegate = self
        
        if NetworkState.isConnected(){
            ws.getBeersList()
        }
    }
    
    //MARK: Bar Items
    
    @IBAction func refreshData(_ sender: Any) {
        
        if NetworkState.isConnected(){
            ws.getBeersList()
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return beers.count
    }

    //MARK: WSDelegate
    
    internal func didSuccessGetBeersWS(result: Data) {

        let json = try? JSONSerialization.jsonObject(with: result, options: [])
        print("DidSuccessGetBeers: ", json ?? "nil")
        
        let  dictionary = json as? [Any]
        
        DispatchQueue.main.async {
            
            if (dictionary != nil && dictionary?.count != 0){
                
                for item in dictionary!{
                    
                    var beer = Beer()
                    
                    let dict = item as? [String: Any]
                    
                    if(dict?["name"] != nil){
                        beer.name = dict?["name"] as! String
                    }
                    if(dict?["image_url"] != nil){
                        beer.url_image = dict?["image_url"] as! String
                    }
                    if(dict?["description"] != nil){
                        beer.description = dict?["description"] as! String
                    }
                    if(dict?["abv"] != nil){
                        beer.abv = dict?["abv"] as! Double
                    }
                    
                    self.beers.append(beer)
                }
                
                self.tableView.reloadData()
            }
        
        }
    }
    
    internal func didFailWS() {
        DispatchQueue.main.async {
            Utils.showAlert(title: "Error", text: "Error de comunicación con el servidor", view: self)
        }
    }

}
