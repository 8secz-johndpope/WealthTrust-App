//
//  MFAccount.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/2/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation
import UIKit

let kAccId = "AccId"
let kclientid = "clientid"
let kRTAamcCode = "RTAamcCode"
let kAmcName = "AmcName"
let kSchemeCode = "SchemeCode"
let kSchemeName = "SchemeName"
let kDivOption = "DivOption"
let kpucharseUnits = "pucharseUnits"
let kpuchaseNAV = "puchaseNAV"
let kInvestmentAmount = "InvestmentAmount"
let kCurrentNAV = "CurrentNAV"
let kNAVDate = "NAVDate"
let kisDeleted = "isDeleted"


class MFAccount: NSObject {
    
    var AccId : String!
    var clientid : String!
    var FolioNo : String!
    var RTAamcCode : String!
    var AmcName : String!
    var SchemeCode : String!
    var SchemeName : String!
    var DivOption : String!
    var pucharseUnits : String!
    var puchaseNAV : String!
    var InvestmentAmount : String!
    var CurrentNAV : String!
    var NAVDate : String!
    var isDeleted : String!

    override init() {
        
    }
    
    init(data: NSDictionary) {
        AccId = data.valueForKey(kAccId) as! String
        clientid = data.valueForKey(kclientid) as! String
        FolioNo = data.valueForKey(kFolioNo) as! String
        RTAamcCode = data.valueForKey(kRTAamcCode) as! String
        AmcName = data.valueForKey(kAmcName) as! String
        SchemeCode = data.valueForKey(kSchemeCode) as! String
        SchemeName = data.valueForKey(kSchemeName) as! String
        DivOption = data.valueForKey(kDivOption) as! String
        pucharseUnits = data.valueForKey(kpucharseUnits) as! String
        puchaseNAV = data.valueForKey(kpuchaseNAV) as! String
        InvestmentAmount = data.valueForKey(kInvestmentAmount) as! String
        CurrentNAV = data.valueForKey(kCurrentNAV) as! String
        NAVDate = data.valueForKey(kNAVDate) as! String
        isDeleted = data.valueForKey(kisDeleted) as! String

    }
    
}
