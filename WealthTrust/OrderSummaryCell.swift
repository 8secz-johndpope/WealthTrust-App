//
//  OrderSummaryCell.swift
//  WealthTrust
//
//  Created by Shree ButBhavani on 30/01/17.
//  Copyright © 2017 Hemen Gohil. All rights reserved.
//

import UIKit

class OrderSummaryCell: UITableViewCell {

    @IBOutlet weak var view1 = UIView()
    @IBOutlet weak var imaView = UIImageView()
    @IBOutlet weak var lblFundName = UILabel()
    @IBOutlet weak var lblType = UILabel()
    @IBOutlet weak var lblSwitTo = UILabel()
    @IBOutlet weak var lblFolio = UILabel()
    @IBOutlet weak var lblPurchaseAmount = UILabel()
    @IBOutlet weak var lblOrderOd = UILabel()
    @IBOutlet weak var lblOrderStatus = UILabel()
    @IBOutlet weak var lblRedeemType = UILabel()
    
    
//    @IBOutlet weak var view1 = UIView()
//    @IBOutlet weak var imaView = UIImageView()
//    @IBOutlet weak var lblFundName = UILabel()
//    @IBOutlet weak var lblType = UILabel()
//    @IBOutlet weak var lblSwitTo = UILabel()
//    @IBOutlet weak var lblFolio = UILabel()
//    @IBOutlet weak var lblPurchaseAmount = UILabel()
//    @IBOutlet weak var lblOrderOd = UILabel()
//    @IBOutlet weak var lblOrderStatus = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
