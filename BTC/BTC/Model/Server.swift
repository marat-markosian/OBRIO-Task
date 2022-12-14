//
//  Server.swift
//  BTC
//
//  Created by Марат Маркосян on 06.10.2022.
//

import UIKit
import CoreData

protocol InfoDelegate {
    
    func updateCost()
    func updateBalance()
    
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
                delegate?.updateCost()
            } catch let error {
              print(error.localizedDescription)
            }
         })

         task.resume()
    }
    
    func saveBalance(_ count: Float) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Balance", in: managedContext)!
        
        let balance = NSManagedObject(entity: entity, insertInto: managedContext)
        
        balance.setValue(count, forKeyPath: "count")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveTransaction(with amount: Float, category: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: managedContext)!
        
        let transaction = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let formattedDate = formatter.string(from: now)
        
        transaction.setValue(amount, forKeyPath: "amount")
        transaction.setValue(category, forKeyPath: "category")
        transaction.setValue(formattedDate, forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getTransactions() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        BitcoinInfo.instance.transactions = []
        do {
            let transactions = try managedContext.fetch(fetchRequest)
            if transactions.count == 0 {
                BitcoinInfo.instance.transactions = []
            } else {
                for transaction in transactions.reversed() {
                    let am = transaction.value(forKeyPath: "amount") as? Float
                    let category = transaction.value(forKeyPath: "category") as? String
                    let date = transaction.value(forKeyPath: "date") as? String
                    let trans = TransactionData(amount: am!, category: category!, date: date!)
                    BitcoinInfo.instance.transactions.append(trans)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    func getBalance() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Balance")
        
        do {
            let balance = try managedContext.fetch(fetchRequest)
            if balance.count == 0 {
                BitcoinInfo.instance.balance = 0
            } else if let count = balance[0].value(forKeyPath: "count") as? Float {
                BitcoinInfo.instance.balance = count
            }
            delegate?.updateBalance()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateBalance(_ count: Float, action: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Balance")

        var newCount  = BitcoinInfo.instance.balance
        if action == "+" {
            newCount  = BitcoinInfo.instance.balance + count
        } else {
            newCount  = BitcoinInfo.instance.balance - count
        }
        BitcoinInfo.instance.balance = newCount
        do {            
            let balance = try managedContext.fetch(fetchRequest)
            if balance.isEmpty {
                saveBalance(newCount)
            } else {
                balance[0].setValue(newCount, forKeyPath: "count")
                try managedContext.save()
            }
            delegate?.updateBalance()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
