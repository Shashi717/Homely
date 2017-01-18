//
//  HistoryTableViewCell.swift
//  Homely
//
//  Created by Jermaine Kelly on 1/12/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    let historyTitleLabel:UILabel = UILabel()
    static let identifier: String = "historyCell"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(historyTitleLabel)
        
        backgroundColor = .clear
        historyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        historyTitleLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 10).isActive = true
        historyTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        historyTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        historyTitleLabel.font = UIFont.systemFont(ofSize: 20)
        historyTitleLabel.numberOfLines = 2
    }
}
