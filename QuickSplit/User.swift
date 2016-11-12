//
//  User.swift
//  QuickSplit
//
//  Created by Kelly Lampotang on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String
    var price : Double
    
    init(usrname:String, price:Double) {
        // set myValue before super.init is called
        self.price = price
        self.username = usrname
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
