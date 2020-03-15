//
//  ProductTableViewCell.swift
//  FYP
//
//  Created by yoshi on 11/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var aDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var aImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
