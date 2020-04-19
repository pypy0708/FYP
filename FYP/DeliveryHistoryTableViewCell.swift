//
//  DeliveryHistoryTableViewCell.swift
//  FYP
//
//  Created by yoshi on 12/4/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class DeliveryHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var total: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
