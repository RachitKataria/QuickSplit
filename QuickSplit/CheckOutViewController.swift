//
//  CheckoutViewController.swift
//  QuickSplit
//
//  Created by MacBook Pro on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var userCheckoutButton1: UIButton!
    @IBOutlet weak var userCheckoutButton2: UIButton!
    @IBOutlet weak var userCheckoutButton3: UIButton!
    @IBOutlet weak var userCheckoutButton4: UIButton!
    
    var arrayUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCheckoutButton1.tag = 1
        userCheckoutButton2.tag = 2
        userCheckoutButton3.tag = 3
        userCheckoutButton4.tag = 4
        
        //        splitButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
}
