//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ImageHeaderView : UIView {
    
//    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = UIColor(hex: "E0E0E0")
//        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
//        self.profileImage.clipsToBounds = true
//        self.profileImage.layer.borderWidth = 1
//        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
//        self.profileImage.setRandomDownloadImage(80, height: 80)
//        self.backgroundImage.setRandomDownloadImage(Int(self.frame.size.width), height: 160)
        
//        let objUser = DBManager.getInstance().getLoggedInUserDetails()
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count != 0 {
            let objUser = allUser.objectAtIndex(0) as! User
            lblUserName.text = objUser.Name
            lblUserEmail.text = objUser.email
        }
    }
}
