//
//  String+Extension.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/6/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation
import UIKit

extension String {
    

    func isAlphanumeric() -> Bool {
        
        var isAlpha = false
        var isNumeric = false

        for chr in self.characters {
            if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z") ) {
                isAlpha = true
            }
            if ((chr >= "0" && chr <= "1")) {
                isNumeric = true
            }
        }
        if isAlpha==true {
            if isNumeric==true {
                return true
            }
        }
        return false
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }


}


extension NSURL {
    func getKeyVals() -> Dictionary<String, String>? {
        var results = [String:String]()
        let keyValues = self.query?.componentsSeparatedByString("&")
        if keyValues?.count > 0 {
            for pair in keyValues! {
                let kv = pair.componentsSeparatedByString("=")
                if kv.count > 1 {
                    results.updateValue(kv[1], forKey: kv[0])
                }
            }
        }
        return results
    }
}

