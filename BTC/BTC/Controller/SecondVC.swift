//
//  SecondVC.swift
//  BTC
//
//  Created by Марат Маркосян on 05.10.2022.
//

import UIKit

protocol TransactionDelegate {
    func updateTransactions()
}

class SecondVC: UIViewController {
    
    private lazy var amountTxt = UITextField()
    private lazy var categoriesTbl = UITableView()
    private lazy var addBtn = UIButton()
    
    var categories = ["Groceries", "Taxi", "Electronics", "Restaurant", "Other"]
    var selectedIndexPath: IndexPath?
    var selectedCategory = ""
    
    var delegate: TransactionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setUpSubviews()
        setUpAutoLayout()
    }

    private func setUpSubviews() {
        view.addSubview(amountTxt)
        view.addSubview(categoriesTbl)
        view.addSubview(addBtn)
        
        amountTxt.placeholder = "Enter amount of transaction"
        amountTxt.keyboardType = .decimalPad
        amountTxt.borderStyle = .roundedRect
        
        categoriesTbl.delegate = self
        categoriesTbl.dataSource = self
        categoriesTbl.register(CustomCell.self, forCellReuseIdentifier: "Reuse")
        
        addBtn.setTitleColor(.black, for: .normal)
        addBtn.setTitle("Add", for: .normal)
        addBtn.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        addBtn.layer.cornerRadius = 5
        addBtn.layer.borderColor = CGColor.init(red: 104/255, green: 240/255, blue: 135/255, alpha: 0.5)
        addBtn.layer.borderWidth = 2
        addBtn.layer.cornerRadius = 10

    }
    
    private func setUpAutoLayout() {
        amountTxt.translatesAutoresizingMaskIntoConstraints = false
        categoriesTbl.translatesAutoresizingMaskIntoConstraints = false
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountTxt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            amountTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            amountTxt.heightAnchor.constraint(equalToConstant: 40),
            amountTxt.widthAnchor.constraint(equalToConstant: 250),
            
            categoriesTbl.topAnchor.constraint(equalTo: amountTxt.bottomAnchor, constant: 20),
            categoriesTbl.heightAnchor.constraint(equalToConstant: 200),
            categoriesTbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesTbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addBtn.topAnchor.constraint(equalTo: categoriesTbl.bottomAnchor, constant: 10),
            addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func showError(descr: String) {
        let alert = UIAlertController(title: "Error", message: descr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }
    
    @objc private func addTransaction() {
        if amountTxt.text == "" || selectedCategory == "" {
            showError(descr: "Try again!")
        } else {
            let amount = Float(amountTxt.text!)!
            Server().saveTransaction(with: amount, category: selectedCategory)
            Server().updateBalance(amount, action: "-")
            delegate?.updateTransactions()
            dismiss(animated: true)
        }
        
        
    }
}

extension SecondVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previous = selectedIndexPath
        selectedIndexPath = indexPath
        
        let allowDeselection = true // optional behavior
        if allowDeselection && previous == selectedIndexPath {
            selectedIndexPath = nil
        }
        
        tableView.reloadRows(at: [previous, selectedIndexPath].compactMap({ $0 }), with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCategory = categories[indexPath.row]
    }
    
}

extension SecondVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") as? CustomCell {
            cell.setTitle(to: categories[indexPath.row])
            cell.accessoryType = (indexPath == selectedIndexPath) ? .checkmark : .none
            return cell
        }
        return UITableViewCell()
    }
    
    
    
}
