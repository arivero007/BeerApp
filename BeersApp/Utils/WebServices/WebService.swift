//
//  WebService.swift
//  BeersApp
//
//  Created by Alexander Rivero on 17/09/2020.
//  Copyright © 2020 Alexander Rivero. All rights reserved.
//

import Foundation


@objc protocol WSDelegate {
    
    @objc optional func didFailWS()
    
    //BeersWS
    @objc optional func didSuccessGetBeersWS(result: Data)


}


class WebService {
    weak var delegate: WSDelegate?
    
    func executeWS(dictParameters: Dictionary<String, Any>, urlServer: String, parameter: String){
                
        guard let aUrl = URL(string: urlServer) else {
            print("No se ha procesado la URL")
            return
        }
        NSLog("dict: %@", dictParameters);
        
        var request = URLRequest.init(url: aUrl, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30.0)
        
        if (parameter != ""){
            //request.setValue(parameter, forHTTPHeaderField: "apiKey")
            request.httpMethod = parameter
        }else{
            request.httpMethod = "POST"
        }

        if(!dictParameters.isEmpty){
            let jsonData = try? JSONSerialization.data(withJSONObject:dictParameters, options:[])
            request.setValue(String.init(format: "%lu",   jsonData?.count ?? 0 ), forHTTPHeaderField: "Content-Length")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "content-type")
        }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
           if error != nil || data == nil {
                   print("Client error!")
                    self.delegate?.didFailWS?()
                   return
               }
               guard let response = response as? HTTPURLResponse, (200...550).contains(response.statusCode) else {
                   print("Server error!")
                   return
               }
                
            print("HTTP code: ", response.statusCode)
            
            if(!data!.isEmpty){
                guard let mime = response.mimeType else{
                    print("No Mime!")
                    return
                }
                print("Mime type: ", mime)
            }
            do {
                if(!data!.isEmpty){
                    
                   let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                       print("Data: ", json)
                    
                       if response.statusCode == 200{
                        
                        if (urlServer == Utils.urlBase){
                            self.delegate?.didSuccessGetBeersWS?(result: data!)
                        }
                        
                       }else if(response.statusCode == 400){
                           
                       }else if(response.statusCode == 401){
                           
                       }else if(response.statusCode == 403){
                        
                       }else{
                           self.delegate?.didFailWS?()
                       }
                }else{
                    if response.statusCode == 200{
                     
                    }else if(response.statusCode == 400){
                        
                    }else if(response.statusCode == 401){
                        
                    }else if(response.statusCode == 403){
                        
                    }else{
                        self.delegate?.didFailWS?()
                    }
                }
                }catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        dataTask.resume()
    }
    
    //MARK: LOGIN
    
    func getBeersList(country: String){
        
        var dict:[String: Any] = [:]
        dict.updateValue(country, forKey: "country")
        self.executeWS(dictParameters: dict, urlServer: Utils.urlBase + "beers", parameter: "")
    }
}
