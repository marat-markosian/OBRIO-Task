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
        server.getBalance()
        
        view.addSubview(btcCost)
        view.addSubview(balance)
        view.addSubview(addBalance)
        view.addSubview(addTransaction)
        
        btcCost.textColor = .black
        btcCost.font = UIFont.init(name: "Avenir", size: 16)
        
        balance.font = UIFont(name: "Avenir-Heavy", size: 40)
        balance.textColor = .black
        balance.text = "0"
        
        addBalance.setTitleColor(.black, for: .normal)
        addBalance.setTitle("Replenish the balance", for: .normal)
        addBalance.layer.cornerRadius = 5
        addBalance.layer.borderColor = CGColor.init(red: 104/255, green: 240/255, blue: 135/255, alpha: 0.5)
        addBalance.layer.borderWidth = 2
        addBalance.layer.cornerRadius = 10
        addBalance.addTarget(self, action: #selector(goToReplenishment), for: .touchUpInside)
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
            balance.topAnchor.constraint(equalTo: btcCost.bottomAnchor, constant: 20),
            
            addBalance.topAnchor.constraint(equalTo: balance.bottomAnchor, constant: 20),
            addBalance.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func goToReplenishment() {
        let nextVC = ReplenishmentVC()
        nextVC.delegate = self
        present(nextVC, animated: true)
    }

}

extension FirstVC: InfoDelegate {
    
    func updateBalance() {
        DispatchQueue.main.async {
            self.balance.text = "\(BitcoinInfo.instance.balance) BTC"
        }
    }
    
    func updateCost() {
        DispatchQueue.main.async {
            self.btcCost.text = "1 BTC = \(BitcoinInfo.instance.rate)$"
        }
    }
    
}

extension FirstVC: ReplenishmentDelegate {
    func replenish(count: Float) {
        server.replenishBalance(count)
    }
    
    
}

