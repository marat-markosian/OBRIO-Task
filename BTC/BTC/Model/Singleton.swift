//
//  Singleton.swift
//  BTC
//
//  Created by Марат Маркосян on 06.10.2022.
//

import Foundation
import CoreData

struct TransactionData {
    let amount: Float
    let category: String
    let date: Date
}

struct BitcoinInfo {
    
    static var instance = BitcoinInfo()
    
    var rate: Float = 0
    var balance: Float = 0
    var transactions: [TransactionData] = []
    
}
