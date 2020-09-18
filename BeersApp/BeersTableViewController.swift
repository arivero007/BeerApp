//
//  BeersTableViewController.swift
//  BeersApp
//
//  Created by Alexander Rivero on 17/09/2020.
//  Copyright © 2020 Alexander Rivero. All rights reserved.
//

import UIKit
import JGProgressHUD

class BeersTableViewController: UITableViewController, WSDelegate, UISearchBarDelegate {
    
    let ws: WebService = WebService()
    var hud: JGProgressHUD?
    
    var beers = [Beer]()
    var filteredBeers = [Beer]()
    
    var selectedBeer = Beer()

    //MARK: UI References
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ws.delegate = self
        searchBar.delegate = self
        
        registerCell()
        
        //Call for beers!
        getBeers()
    }
    
    //MARK: Bar Items
    
    @IBAction func refreshData(_ sender: Any) {
        getBeers()
    }
    
    // MARK: - Search bar data source
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredBeers = []
        
        if searchText == ""{
            filteredBeers = beers
        }else{
            for beer in beers{
                
                if beer.name.contains(searchText){
                    filteredBeers.append(beer)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredBeers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? BeerTableViewCell else {
            return UITableViewCell()
        }
        
        cell.beerName.text = filteredBeers[indexPath.item].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedBeer = filteredBeers[indexPath.item]
        
        performSegue(withIdentifier: "segueBeer", sender: nil)
    }
    
    //MARK: FUNCTIONS
    
    private func registerCell() {
        let cell = UINib(nibName: "BeerTableViewCell",
                            bundle: nil)
        self.tableView.register(cell,
                                forCellReuseIdentifier: "menuCell")
    }
    
    private func getBeers(){
        
        if NetworkState.isConnected(){
            hud = JGProgressHUD(style: .dark)
            hud?.textLabel.text = "Cargando..."
            hud?.show(in: self.view)
            ws.getBeersList()
        }else{
            Utils.showAlert(title: "Error", text: "No hay conexión a internet", view: self)
        }
    }
    
    //MARK: NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueBeer"){
            let cp = segue.destination as! BeerViewController
            cp.beer = self.selectedBeer
        }
    }

    //MARK: WSDelegate
    
    internal func didSuccessGetBeersWS(result: Data) {

        let json = try? JSONSerialization.jsonObject(with: result, options: [])
        print("DidSuccessGetBeers: ", json ?? "nil")
        
        let  dictionary = json as? [Any]
        
        DispatchQueue.main.async {
            
            self.hud?.dismiss()
            
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
                
                self.filteredBeers = self.beers
                self.tableView.reloadData()
            }
        
        }
    }
    
    internal func didSuccessGetBeersWS() {
        //Not needed now
        hud?.dismiss()
        Utils.showAlert(title: "Aviso", text: "No se han recibido datos", view: self)
        
    }
    
    internal func didFailWS() {
        DispatchQueue.main.async {
            self.hud?.dismiss()
            Utils.showAlert(title: "Error", text: "Error de comunicación con el servidor", view: self)
        }
    }

}
