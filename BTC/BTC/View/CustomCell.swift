//
//  CustomCell.swift
//  BTC
//
//  Created by Марат Маркосян on 10.10.2022.
//

import UIKit

class CustomCell: UITableViewCell {
    
    private lazy var titleLbl = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setLabel()
    }
    
    private func setLabel() {
        addSubview(titleLbl)
        backgroundColor = .white
        
        titleLbl.textColor = .black
        titleLbl.font = UIFont(name: "Avenir", size: 16)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        titleLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setTitle(to name: String) {
        titleLbl.text = name
    }

}
