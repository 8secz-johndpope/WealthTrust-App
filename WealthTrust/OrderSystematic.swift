//
//  OrderSystematic.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/2/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation

import UIKit

let kFrequency = "Frequency"
let kDay = "Day"
let kStart_Month = "Start_Month"
let kStart_Year = "Start_Year"
let kEnd_Month = "End_Month"
let kEnd_Year = "End_Year"
let kNoOfInstallments = "NoOfInstallments"
let kFirstPaymentAmount = "FirstPaymentAmount"
let kFirstPaymentFlag = "FirstPaymentFlag"

class OrderSystematic: NSObject {
    
    var AppOrderID : String!
    var Frequency : String!
    var Day : String!
    var Start_Month : String!
    var Start_Year : String!
    var End_Month : String!
    var End_Year : String!
    var NoOfInstallments : String!
    var FirstPaymentAmount : String!
    var FirstPaymentFlag : String!

    override init() {
        
    }
    
    init(data: NSDictionary) {
        
        AppOrderID = data.valueForKey(kAppOrderID) as! String
        Frequency = data.valueForKey(kFrequency) as! String
        Day = data.valueForKey(kDay) as! String
        Start_Month = data.valueForKey(kStart_Month) as! String
        Start_Year = data.valueForKey(kStart_Year) as! String
        End_Month = data.valueForKey(kEnd_Month) as! String
        End_Year = data.valueForKey(kEnd_Year) as! String
        NoOfInstallments = data.valueForKey(kNoOfInstallments) as! String
        FirstPaymentAmount = data.valueForKey(kFirstPaymentAmount) as! String
        FirstPaymentFlag = data.valueForKey(kFirstPaymentFlag) as! String

    }
    
}
