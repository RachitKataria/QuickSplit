//
//  CheckoutViewController.swift
//  QuickSplit
//
//  Created by MacBook Pro on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class Checkout2ViewController: UIViewController {
    
    @IBOutlet weak var userCheckoutButton1: UIButton!
    @IBOutlet weak var userCheckoutButton2: UIButton!
    @IBOutlet weak var userCheckoutButton3: UIButton!
    @IBOutlet weak var userCheckoutButton4: UIButton!
    
    var arrayUsers = [User]()
    
    var arrayButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.arrayButtons.append(self.userCheckoutButton1)
            self.arrayButtons.append(self.userCheckoutButton2)
            self.arrayButtons.append(self.userCheckoutButton3)
            self.arrayButtons.append(self.userCheckoutButton4)
            
            for i in 0...self.arrayButtons.capacity - 1 {
                self.arrayButtons[i].tag = i + 1
            }
            
            for i in 0...self.arrayButtons.capacity - 1 {
                self.arrayButtons[i].addTarget(self,action:#selector(self.buttonClicked),for:.touchUpInside)
            }
            
            //        splitButton.isHidden = true
            // Do any additional setup after loading the view.
        }
        
    }
    
    func buttonClicked(sender: UIButton) {
        Venmo.openVenmoCharge(recipients: [arrayUsers[sender.tag].username], amount: arrayUsers[sender.tag].price)
    }
    
}
