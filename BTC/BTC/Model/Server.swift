//
//  Server.swift
//  BTC
//
//  Created by Марат Маркосян on 06.10.2022.
//

import Foundation

protocol InfoDelegate {
    
    func updateInfo()
    
}

struct B: Decodable {
    let bpi: USDS
}

struct USDS: Decodable {
    let USD: Info
}

struct Info: Decodable {
    let rate_float: Float
}

struct Server {
    
    var delegate: InfoDelegate?
    
    func getBTCcost() {
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else { return }
              
         let session = URLSession.shared
         let request = URLRequest(url: url)
              
         let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                  
             guard error == nil else {
                 return
             }
                  
             guard let data = data else {
                 return
             }
                  
            do {
               //create json object from data
                let newData = try! JSONDecoder().decode(B.self, from: data)
                BitcoinInfo.instance.rate = newData.bpi.USD.rate_float
                delegate?.updateInfo()
            } catch let error {
              print(error.localizedDescription)
            }
         })

         task.resume()
    }
    
}
