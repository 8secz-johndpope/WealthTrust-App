//
//  Order.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/26/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

let kAppOrderID = "AppOrderID"
let kServerOrderID = "ServerOrderID"
let kFolioNo = "FolioNo"
let kFolioCheckDigit = "FolioCheckDigit"
let kRtaAmcCode = "RtaAmcCode"
let kSrcSchemeCode = "SrcSchemeCode"
let kSrcSchemeName = "SrcSchemeName"
let kTarSchemeCode = "TarSchemeCode"
let kTarSchemeName = "TarSchemeName"
let kDividendOption = "DividendOption"
let kVolumeType = "VolumeType"
let kVolume = "Volume"
let kOrderType = "OrderType"
let kOrderStatus = "OrderStatus"
let kAppOrderTimeStamp = "AppOrderTimeStamp"
let kCartFlag = "CartFlag"
let kUpdateTime = "UpdateTime"

class Order: NSObject {
    
    var AppOrderID : String!
    var ServerOrderID : String!
    var ClientID : String!
    var FolioNo : String!
    var FolioCheckDigit : String!
    var RtaAmcCode : String!
    var SrcSchemeCode : String!
    var SrcSchemeName : String!
    var TarSchemeCode : String!
    var TarSchemeName : String!
    var DividendOption : String!
    var VolumeType : String!
    var Volume : String!
    var OrderType : String!
    var OrderStatus : String!
    var AppOrderTimeStamp : String!
    var CartFlag : String!
    var UpdateTime : String!
    var txnPurchaseUnits : String!
    var txnPurchaseNav : String!
    var txnPurchaseAmount : String!
    var executionDateTime : String!

    override init() {
        
    }
    
    init(data: NSDictionary) {
        
        AppOrderID = data.valueForKey(kAppOrderID) as! String
        ServerOrderID = data.valueForKey(kServerOrderID) as! String
        ClientID = data.valueForKey(kClientID) as! String
        FolioNo = data.valueForKey(kFolioNo) as! String
        FolioCheckDigit = data.valueForKey(kFolioCheckDigit) as! String
        RtaAmcCode = data.valueForKey(kRtaAmcCode) as! String
        SrcSchemeCode = data.valueForKey(kSrcSchemeCode) as! String
        SrcSchemeName = data.valueForKey(kSrcSchemeName) as! String
        TarSchemeCode = data.valueForKey(kTarSchemeCode) as! String
        TarSchemeName = data.valueForKey(kTarSchemeName) as! String
        DividendOption = data.valueForKey(kDividendOption) as! String
        VolumeType = data.valueForKey(kVolumeType) as! String
        Volume = data.valueForKey(kVolume) as! String
        OrderType = data.valueForKey(kOrderType) as! String
        OrderStatus = data.valueForKey(kOrderStatus) as! String
        AppOrderTimeStamp = data.valueForKey(kAppOrderTimeStamp) as! String
        CartFlag = data.valueForKey(kCartFlag) as! String
        UpdateTime = data.valueForKey(kUpdateTime) as! String
    }
    
}
