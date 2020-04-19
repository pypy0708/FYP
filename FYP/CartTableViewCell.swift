//
//  CartTableViewCell.swift
//  FYP
//
//  Created by yoshi on 12/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        quantity.layer.borderColor = UIColor.gray.cgColor
        quantity.layer.borderWidth = 1.0
        quantity.layer.cornerRadius = 10
    }

}
