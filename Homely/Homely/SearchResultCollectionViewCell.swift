//
//  SearchResultCollectionViewCell.swift
//  Homely
//
//  Created by Madushani Lekam Wasam Liyanage on 1/10/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit
import expanding_collection

class SearchResultCollectionViewCell: BasePageCollectionCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.layer.shadowRadius = 2
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleLabel.layer.shadowOpacity = 0.2
        
    }

}
