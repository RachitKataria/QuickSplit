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
    
    var arrayButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayButtons.append(userCheckoutButton1)
        arrayButtons.append(userCheckoutButton2)
        arrayButtons.append(userCheckoutButton3)
        arrayButtons.append(userCheckoutButton4)
        
        for i in 0...arrayButtons.capacity {
            arrayButtons[i].tag = i + 1
        }
        
        for i in 0...arrayButtons.capacity {
            arrayButtons[i].addTarget(self,action:#selector(buttonClicked),for:.touchUpInside)
        }
        
        //        splitButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func buttonClicked(sender: UIButton) {
        
        if(sender.tag == 1) {
            print(getVenmoURL(username: arrayUsers[0].username, price: arrayUsers[0].price))
        } else if(sender.tag == 2) {
            print(getVenmoURL(username: arrayUsers[1].username, price: arrayUsers[1].price))
        } else if(sender.tag == 3) {
            print(getVenmoURL(username: arrayUsers[2].username, price: arrayUsers[2].price))
        } else if(sender.tag == 4) {
            print(getVenmoURL(username: arrayUsers[3].username, price: arrayUsers[3].price))
        }
    }
    
    func getVenmoURL(username: String, price: Double) -> String {
        
        
        // need to add logic for the note
        
        let myPrice = price
        let x = String(myPrice)
        
        var note = "hai hai"
        
        note = note.replacingOccurrences(of: " ", with: "%20");
        
        //        venmoURL = ("https://venmo.com/?txn=charge&audience=public&recipients=")
        
        var venmoURL = ("venmo://paycharge?txn=charge&audience=public&recipients=")
        
        venmoURL.append(username)
        venmoURL.append("&amount=")
        venmoURL.append(x)
        venmoURL.append("&note=")
        venmoURL.append(note)
        
        return venmoURL
    }
    
}
