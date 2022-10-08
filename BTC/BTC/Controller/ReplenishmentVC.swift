//
//  ReplenishmentVC.swift
//  BTC
//
//  Created by Марат Маркосян on 07.10.2022.
//

import UIKit

protocol ReplenishmentDelegate {
    func replenish(count: Float)
}

class ReplenishmentVC: UIViewController {
    
    var delegate: ReplenishmentDelegate?
    
    private lazy var titleLabel = UILabel()
    private lazy var btcTxt = UITextField()
    private lazy var replenishBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setUpSubviews()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(btcTxt)
        view.addSubview(replenishBtn)

        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 25)
        titleLabel.textColor = .black
        titleLabel.text = "BTC count to replenish:"
        
        btcTxt.keyboardType = .decimalPad
        btcTxt.placeholder = "BTC count"
        btcTxt.borderStyle = .roundedRect
        
        replenishBtn.setTitleColor(.black, for: .normal)
        replenishBtn.setTitle("Replenish", for: .normal)
        replenishBtn.addTarget(self, action: #selector(replenishBalance), for: .touchUpInside)
        replenishBtn.layer.cornerRadius = 5
        replenishBtn.layer.borderColor = CGColor.init(red: 104/255, green: 240/255, blue: 135/255, alpha: 0.5)
        replenishBtn.layer.borderWidth = 2
        replenishBtn.layer.cornerRadius = 10

    }
    
    private func setUpAutoLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        btcTxt.translatesAutoresizingMaskIntoConstraints = false
        replenishBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            btcTxt.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            btcTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btcTxt.heightAnchor.constraint(equalToConstant: 40),
            btcTxt.widthAnchor.constraint(equalToConstant: 150),
            
            replenishBtn.topAnchor.constraint(equalTo: btcTxt.bottomAnchor, constant: 30),
            replenishBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
    
    @objc private func replenishBalance() {
        if let count = Float(btcTxt.text!) {
            delegate?.replenish(count: count)
            dismiss(animated: true)
        }
    }
}
