//
//  MFTransaction.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/2/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation
import UIKit

let kTxnID = "TxnID"
let kAccID = "AccID"
let kOrderId = "OrderId"
let kTxnOrderDateTime = "TxnOrderDateTime"
let kTxtType = "TxtType"
let kTxnpucharseUnits = "TxnpucharseUnits"
let kTxnpuchaseNAV = "TxnpuchaseNAV"
let kTxnPurchaseAmount = "TxnPurchaseAmount"
let kExecutaionDateTime = "ExecutaionDateTime"

class MFTransaction: NSObject {
    
    var TxnID : String!
    var AccID : String!
    var OrderId : String!
    var TxnOrderDateTime : String!
    var TxtType : String!
    var TxnpucharseUnits : String!
    var TxnpuchaseNAV : String!
    var TxnPurchaseAmount : String!
    var ExecutaionDateTime : String!
    var isDeleted : String!

    override init() {
        
    }
    
    init(data: NSDictionary) {
        TxnID = data.valueForKey(kTxnID) as! String
        AccID = data.valueForKey(kAccID) as! String
        OrderId = data.valueForKey(kOrderId) as! String
        TxnOrderDateTime = data.valueForKey(kTxnOrderDateTime) as! String
        TxtType = data.valueForKey(kTxtType) as! String
        TxnpucharseUnits = data.valueForKey(kTxnpucharseUnits) as! String
        TxnpuchaseNAV = data.valueForKey(kTxnpuchaseNAV) as! String
        TxnPurchaseAmount = data.valueForKey(kTxnPurchaseAmount) as! String
        ExecutaionDateTime = data.valueForKey(kExecutaionDateTime) as! String
        isDeleted = data.valueForKey(kisDeleted) as! String

    }
    
}
