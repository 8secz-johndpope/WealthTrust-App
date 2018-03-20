//
//  AOFStatus.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/20/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

//let kClientID = "ClientID"
let kPanCopy = "pancopy"
let kChequeCopy = "chequecopy"
let kSelfie = "selfie"
let kDobmismatch = "dobmismatch"
let kNameMismatch = "namemismatch"
let kSignaturemismatch = "signaturemismatch"
let kBanckaccmismatch = "banckaccmismatch"
let kIFSCmismatch = "ifscmismatch"
let kPannummismatch = "pannummismatch"
let kAOFtype = "aoftype"
let kIdS = "IdS"

class AOFStatus: NSObject {

    var ClientID : String!
    var pancopy : String!
    var chequecopy : String!
    var selfie : String!
    var dobmismatch : String!
    var namemismatch : String!
    var signaturemismatch : String!
    var banckaccmismatch : String!
    var ifscmismatch : String!
    var pannummismatch : String!
    var aoftype : String!
    var idS : String!
    
    override init() {
        
    }
    
    init(data: NSDictionary) {
        
        ClientID = data.valueForKey(kClientID) as! String
        pancopy = data.valueForKey(kPanCopy) as! String
        chequecopy = data.valueForKey(kChequeCopy) as! String
        selfie = data.valueForKey(kSelfie) as! String
        dobmismatch = data.valueForKey(kDobmismatch) as! String
        namemismatch = data.valueForKey(kNameMismatch) as! String
        signaturemismatch = data.valueForKey(kSignaturemismatch) as! String
        banckaccmismatch = data.valueForKey(kBanckaccmismatch) as! String
        ifscmismatch = data.valueForKey(kIFSCmismatch) as! String
        pannummismatch = data.valueForKey(kPannummismatch) as! String
        aoftype = data.valueForKey(kAOFtype) as! String
        idS = data.valueForKey(kIdS) as! String

    }

}
