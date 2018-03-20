//
//  PayEzzMandate.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/4/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation

import UIKit

let kMandateID = "MandateID"
let kclientID = "clientID"
let ksubSeq_invAccType = "subSeq_invAccType"
let ksubSeq_invAccNo = "subSeq_invAccNo"
let ksubSeq_micrNo = "subSeq_micrNo"
let ksubSeq_ifscCode = "subSeq_ifscCode"
let ksubSeq_bankId = "subSeq_bankId"
let ksubSeq_maximumAmount = "subSeq_maximumAmount"
let ksubSeq_perpetualFlag = "subSeq_perpetualFlag"
let ksubSeq_startDate = "subSeq_startDate"
let ksubSeq_endDate = "subSeq_endDate"
let ksubSeq_paymentRefNo = "subSeq_paymentRefNo"
let kFilePath = "FilePath"
let kAndroidAppSync = "AndroidAppSync"
let kPayEzzStatus = "PayEzzStatus"


class PayEzzMandate: NSObject {
    
    var MandateID : String!
    var clientID : String!
    var subSeq_invAccType : String!
    var subSeq_invAccNo : String!
    var subSeq_micrNo : String!
    var subSeq_ifscCode : String!
    var subSeq_bankId : String!
    var subSeq_maximumAmount : String!
    var subSeq_perpetualFlag : String!
    var subSeq_startDate : String!
    var subSeq_endDate : String!
    var subSeq_paymentRefNo : String!
    var FilePath : String!
    var AndroidAppSync : String!
    var PayEzzStatus : String!

    override init() {
        
    }
    
    init(data: NSDictionary) {
        
        MandateID = data.valueForKey(kMandateID) as! String
        clientID = data.valueForKey(kclientID) as! String
        subSeq_invAccType = data.valueForKey(ksubSeq_invAccType) as! String
        subSeq_invAccNo = data.valueForKey(ksubSeq_invAccNo) as! String
        subSeq_micrNo = data.valueForKey(ksubSeq_micrNo) as! String
        subSeq_ifscCode = data.valueForKey(ksubSeq_ifscCode) as! String
        subSeq_bankId = data.valueForKey(ksubSeq_bankId) as! String
        subSeq_maximumAmount = data.valueForKey(ksubSeq_maximumAmount) as! String
        subSeq_perpetualFlag = data.valueForKey(ksubSeq_perpetualFlag) as! String
        subSeq_startDate = data.valueForKey(ksubSeq_startDate) as! String
        subSeq_endDate = data.valueForKey(ksubSeq_endDate) as! String
        subSeq_paymentRefNo = data.valueForKey(ksubSeq_paymentRefNo) as! String
        FilePath = data.valueForKey(kFilePath) as! String
        AndroidAppSync = data.valueForKey(kAndroidAppSync) as! String
        PayEzzStatus = data.valueForKey(kPayEzzStatus) as! String

    }
}
