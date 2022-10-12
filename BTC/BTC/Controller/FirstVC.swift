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
    private lazy var transactionsTbl = UITableView()
    
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
        server.getTransactions()
        
        view.addSubview(btcCost)
        view.addSubview(balance)
        view.addSubview(addBalance)
        view.addSubview(addTransaction)
        view.addSubview(transactionsTbl)
        
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
        
        addTransaction.setTitleColor(.black, for: .normal)
        addTransaction.setTitle("Add transaction", for: .normal)
        addTransaction.layer.cornerRadius = 5
        addTransaction.layer.borderColor = CGColor.init(red: 104/255, green: 240/255, blue: 135/255, alpha: 0.5)
        addTransaction.layer.borderWidth = 2
        addTransaction.layer.cornerRadius = 10
        addTransaction.addTarget(self, action: #selector(goToTransactionVC), for: .touchUpInside)
        
        transactionsTbl.delegate = self
        transactionsTbl.dataSource = self
        transactionsTbl.register(CustomCell.self, forCellReuseIdentifier: "Reuse")
    }
    
    private func setUpAutoLayout() {
        btcCost.translatesAutoresizingMaskIntoConstraints = false
        balance.translatesAutoresizingMaskIntoConstraints = false
        addBalance.translatesAutoresizingMaskIntoConstraints = false
        addTransaction.translatesAutoresizingMaskIntoConstraints = false
        transactionsTbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btcCost.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            btcCost.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            balance.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            balance.topAnchor.constraint(equalTo: btcCost.bottomAnchor, constant: 20),
            
            addBalance.topAnchor.constraint(equalTo: balance.bottomAnchor, constant: 20),
            addBalance.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addTransaction.topAnchor.constraint(equalTo: addBalance.bottomAnchor, constant: 20),
            addTransaction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            transactionsTbl.topAnchor.constraint(equalTo: addTransaction.bottomAnchor, constant: 20),
            transactionsTbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            transactionsTbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsTbl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func goToReplenishment() {
        let nextVC = ReplenishmentVC()
        nextVC.delegate = self
        present(nextVC, animated: true)
    }
    
    @objc private func goToTransactionVC() {
        let secondVC = SecondVC()
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.delegate = self
        present(secondVC, animated: true)
    }

}

extension FirstVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension FirstVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BitcoinInfo.instance.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = BitcoinInfo.instance.transactions[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") as? CustomCell {
            if transaction.category == "Replenishment" {
                let title = "+\(transaction.amount) \(transaction.category) \(transaction.date)"
                cell.setTitle(to: title)
            } else {
                let title = "-\(transaction.amount) \(transaction.category) \(transaction.date)"
                cell.setTitle(to: title)
            }
            return cell
        }
        return UITableViewCell()
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
        server.saveTransaction(with: count, category: "Replenishment")
        server.replenishBalance(count, action: "+")
        server.getTransactions()
        DispatchQueue.main.async {
            self.transactionsTbl.reloadData()
        }
    }
}

extension FirstVC: TransactionDelegate {
    func updateTransactions() {
        server.getTransactions()
        transactionsTbl.reloadData()
        updateBalance()
    }
}

