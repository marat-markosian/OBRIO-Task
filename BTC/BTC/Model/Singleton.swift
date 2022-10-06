//
//  Singleton.swift
//  BTC
//
//  Created by Марат Маркосян on 06.10.2022.
//

import Foundation

struct BitcoinInfo {
    
    static var instance = BitcoinInfo()
    
    var rate: Float = 0
    var balance: Float = 0
    
}
