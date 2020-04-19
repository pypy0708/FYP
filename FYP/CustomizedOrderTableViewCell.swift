//
//  testingTableViewCell.swift
//  FYP
//
//  Created by yoshi on 28/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class CustomizedOrderTableViewCell: UITableViewCell {


    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
