//
//  UIImageViewExtension.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 8/24/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }

    class var defaultAppColorBlue:UIColor {
        get {
            return UIColor(red:27/250, green:129/250, blue:224/250, alpha: 1)
        }
    }

    class var defaultAppBackground:UIColor {
        get {
            return UIColor(red:247/250, green:247/250, blue:247/250, alpha: 1)
        }
    }

    class var defaultOrangeButton:UIColor {
        get {
            return UIColor(red:254/250, green:115/250, blue:12/250, alpha: 1)
        }
    }
    
    class var defaultYellow:UIColor {
        get {
            return UIColor(red:239/250, green:160/250, blue:70/250, alpha: 1)
        }
    }

    class var defaultEmailBlue:UIColor {
        get {
            return UIColor(red:0/250, green:0/250, blue:139/250, alpha: 1)
        }
    }
    class var defaultStatusBlue:UIColor {
        get {
            return UIColor(red:23/250, green:107/250, blue:204/250, alpha: 1)
        }
    }

    class var defaultMenuGray:UIColor {
        get {
            return UIColor(red:144/250, green:144/250, blue:144/250, alpha: 1)
        }
    }
    class var defaultFontSubGray:UIColor {
        get {
            return UIColor(red:85/250, green:85/250, blue:85/250, alpha: 1)
        }
    }

    class var defaultGreenColor:UIColor {
        get {
            return UIColor(red:67/250, green:165/250, blue:71/250, alpha: 1)
        }
    }

}
