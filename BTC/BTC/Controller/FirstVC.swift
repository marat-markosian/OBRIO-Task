//
//  ViewController.swift
//  BTC
//
//  Created by Марат Маркосян on 05.10.2022.
//

import UIKit
import CoreData

class FirstVC: UIViewController {
    
    private lazy var btcCost = UILabel()
    private lazy var balance = UILabel()
    private lazy var addBalance = UIButton()
    private lazy var addTransaction = UIButton()
    
    var server = Server()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setUpSubviews()
        setUpAutoLayout()
    }

    private func setUpSubviews() {
        server.delegate = self
        server.getBTCcost()
        
        view.addSubview(btcCost)
        view.addSubview(balance)
        view.addSubview(addBalance)
        view.addSubview(addTransaction)
        
        btcCost.textColor = .black
        btcCost.font = UIFont.init(name: "Avenir", size: 16)
        
        balance.font = UIFont(name: "Avenir-Heavy", size: 40)
        balance.textColor = .black
        balance.text = "0"
    }
    
    private func setUpAutoLayout() {
        btcCost.translatesAutoresizingMaskIntoConstraints = false
        balance.translatesAutoresizingMaskIntoConstraints = false
        addBalance.translatesAutoresizingMaskIntoConstraints = false
        addTransaction.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btcCost.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            btcCost.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            balance.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            balance.topAnchor.constraint(equalTo: btcCost.bottomAnchor, constant: 20)
        ])
    }

}

extension FirstVC: InfoDelegate {
    
    func updateInfo() {
        DispatchQueue.main.async {
            self.btcCost.text = "1 BTC = \(BitcoinInfo.instance.rate)$"
        }
    }
    
}

