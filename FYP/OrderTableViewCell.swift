//
//  OrderTableViewCell.swift
//  FYP
//
//  Created by yoshi on 21/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
