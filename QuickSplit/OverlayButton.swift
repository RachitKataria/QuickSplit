//
//  OverlayButton.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class OverlayButton: UIButton {

    var price: Double
    var counter:Int
    var selecteder = false
    
    init(frame: CGRect, price: Double) {
        // set myValue before super.init is called
        self.price = price
        self.counter = 0
        
        // init button
        super.init(frame: frame)
        
        // set title & customize
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let priceString: String = formatter.string(from: price as NSNumber)!
        self.setTitle(priceString, for: .normal)
        self.sizeToFit()
        
        // padding
        self.titleEdgeInsets.left = 10;
        self.titleEdgeInsets.right = 10;
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
    }
    
    func reload() {
        self.isEnabled = false
        self.isEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func checkSelected() {
        if(self.selecteder) {
            self.selecteder = false
            counter -= 1
            backgroundColor = UIColor.black
            alpha = 0.5
        }
        else {
            self.selecteder = true
            counter += 1
            backgroundColor = UIColor(red:0.25, green:0.85, blue:0.28, alpha:1.0)
            alpha = 1.0
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
