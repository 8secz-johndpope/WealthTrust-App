//
//  DynamicText.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/2/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation
import UIKit

let kText_type = "text_type"
let kTitle = "title"
let kText = "text"


class DynamicText: NSObject {
    
    var text_type : String!
    var title : String!
    var text : String!

    override init() {
        
    }
    
    init(data: NSDictionary) {
        
        text_type = data.valueForKey(kText_type) as! String
        title = data.valueForKey(kTitle) as! String
        text = data.valueForKey(kText) as! String
    }    
}
