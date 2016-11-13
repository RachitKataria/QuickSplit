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
            
            let maxSize = self.arrayUsers.count
            
            for i in 0...self.arrayUsers.count - 1 {
                self.arrayButtons[i].setTitle("Send a request to " + self.arrayUsers[i].username, for: .normal)
                
            }
            
            if(self.arrayButtons.count > maxSize) {
                for i in maxSize...self.arrayButtons.count - 1 {
                    self.arrayButtons[i].isHidden = true
                }
            }
            
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
