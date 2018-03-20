//
//  MfuPortfolioWorth.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/15/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation

let kportfolio_date = "portfolio_date"
let kCurrentValue = "CurrentValue"
let kIsTransaction = "IsTransaction"

class MfuPortfolioWorth: NSObject {
    
    var portfolio_date : String!
    var AccId : String!
    var pucharseUnits : Double!
    var CurrentNAV : Double!
    var CurrentValue : Double!
    var isTransaction : Int!
    
    override init() {
        
    }

    init(data: NSDictionary) {
        portfolio_date = data.valueForKey(kportfolio_date) as! String
        AccId = data.valueForKey(kAccId) as! String
        pucharseUnits = data.valueForKey(kpucharseUnits) as! Double
        CurrentNAV = data.valueForKey(kCurrentNAV) as! Double
        CurrentValue = data.valueForKey(kCurrentValue) as! Double
        isTransaction = data.valueForKey(kIsTransaction) as! Int

    }
}
