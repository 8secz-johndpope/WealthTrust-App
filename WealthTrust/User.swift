//
//  User.swift
//  MVCSwift
//
//  Created by Hemen Gohil on 5/6/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

let kClientID = "ClientID"
let kName = "Name"
let kEmail = "email"
let kMob = "mob"
let kPassword = "password"
let kCAN = "CAN"
let kSignupStatus = "signupStatus"
let kInvestmentAofStatus = "investmentAofStatus"

class User: NSObject {

    var ClientID : String!
    var Name : String!
    var email : String!
    var mob : String!
    var password : String!
    var CAN : String!
    var SignupStatus : String!
    var InvestmentAofStatus : String!

    override init() {

    }

    init(data: NSDictionary) {
        ClientID = data.valueForKey(kClientID) as! String
        Name = data.valueForKey(kName) as! String
        email = data.valueForKey(kEmail) as! String
        mob = data.valueForKey(kMob) as! String
        password = data.valueForKey(kPassword) as! String
        CAN = data.valueForKey(kCAN) as! String
        SignupStatus = data.valueForKey(kSignupStatus) as! String
        InvestmentAofStatus = data.valueForKey(kInvestmentAofStatus) as! String

    }

}
