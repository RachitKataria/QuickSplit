//
//  ChooseItemViewController.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class ChooseItemViewController: UIViewController {

    var receiptURL: String = ""
    var usernames: [String] = []
    var image: UIImage?
    var counter = 0
    var users: [User] = []
    
    var usernameToButtonMap: [String:[DeepLinkButton]] = [:]
    var buttons : [DeepLinkButton] = []
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        receiptImageView.image = self.image
        //do call with the url
        
        usernameLabel.text = usernames[counter]
        // Do any additional setup after loading the view.
        
        for username in usernames {
            usernameToButtonMap[username] = nil
        }
        
        buttons = createDeepLinkButtons()
        
        for button in buttons {
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }

    func buttonAction(sender: DeepLinkButton!) {
        sender.checkSelected()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createDeepLinkButtons() {
        let arr = readReceipt(url: receiptURL) as [NSDictionary]
        
        var dlbarr : [DeepLinkButton] = []
        for a in arr {
            let boundaries = a["boundaryBox"] as! NSDictionary
            let y = boundaries["top"] as! Int
            let x = boundaries["left"] as! Int
            let width = boundaries["width"] as! Int
            let height = boundaries["height"] as! Int
            let price = a["price"] as! Float
            print(y)
            print(x)
            print(width)
            print(height)
            print(price)
            let frame = CGRect(x: x, y: y, width: width, height: height)
            let dlb = DeepLinkButton(frame: frame, price: Double(price));
            dlbarr.append(dlb)
        }
        
        
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        for button in buttons {
            if(button.isSelected) {
                usernameToButtonMap[usernames[counter]]!.append(button)
            }
        }
        
        counter += 1
        
        if(counter == usernames.count) {
            // Logic to determine price per user
            
            var price: Double = 0
            for username in usernameToButtonMap.keys {
                for button in usernameToButtonMap[username]! {
                    price += button.getPrice() / Double(button.getCount())
                }
                
                let user = User(usrname: username, price: price)
                users.append(user)
                
                price = 0
                
                
            }
        }
        else {
            for button in buttons {
                button.reset()
            }
            
            usernameLabel.text = usernames[counter]
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func readReceipt(url: String) -> [NSDictionary]{
        let arr = [NSDictionary]()
        return arr as! [NSDictionary]
    }

}
