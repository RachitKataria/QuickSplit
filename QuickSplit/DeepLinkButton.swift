//
//  DeepLinkButton.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class DeepLinkButton: UIButton {

    var price: Double
    var counter:Int
    var selecteder = false
    
    init(frame: CGRect, price: Double) {
        // set myValue before super.init is called
        self.price = price
        self.counter = 0
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func checkSelected() {
        if(self.selecteder) {
            self.selecteder = false
            counter -= 1
            backgroundColor = UIColor.gray
        }
        else {
            self.selecteder = true
            counter += 1
            backgroundColor = UIColor.green
        }
    }
    
    func getCount() -> Int {
        return counter
    }
    
    func getPrice() -> Double {
        return price
    }
    
    func reset() {
        self.selecteder = false
        backgroundColor = UIColor.gray
    }
    func incrementCounter() {
        counter += 1
    }
 }
