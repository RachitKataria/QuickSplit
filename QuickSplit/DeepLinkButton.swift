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
    var selected: Bool

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
    }
    
    init(frame: CGRect, price: Double) {
        // set myValue before super.init is called
        self.price = price
        self.counter = 0
        self.selected = false
        alpha = 0.3
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func checkSelected() {
        if(self.selected) {
            self.selected = false
            counter -= 1
            backgroundColor = UIColor.gray
        }
        else {
            self.selected = true
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
        self.selected = false
        backgroundColor = UIColor.gray
    }
}
