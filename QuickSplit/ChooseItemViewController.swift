//
//  ChooseItemViewController.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class ChooseItemViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var receiptURL: String = ""
    var usernames: [String] = []
    var image: UIImage?
    
    var usernameToButtonMap: [String:[OverlayButton]] = [:]
    var buttons : [OverlayButton] = []
    var username: String?
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        receiptImageView.image = self.image
        //do call with the url
        
        usernameLabel.text = username!
        // Do any additional setup after loading the view.
        
        readReceipt(url: receiptURL)
        
        for button in buttons {
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
        
        // do shit to imageview
        receiptImageView.layer.masksToBounds = false
        receiptImageView.clipsToBounds = true
        receiptImageView.layer.cornerRadius = 5
        receiptImageView.layer.borderWidth = 2
        receiptImageView.layer.borderColor = UIColor(red: 0.0, green:0.0, blue:0.0, alpha: 0.5).cgColor
        
//        receiptImageView.layer.shadowOpacity = 0.25
//        receiptImageView.layer.shadowColor = UIColor.black.cgColor
//        receiptImageView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        receiptImageView.layer.shadowRadius = 14
//        receiptImageView.layer.shouldRasterize = true
        
    }
    
    func buttonAction(sender: OverlayButton!) {
        sender.checkSelected()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createOverlayButtons(result: [[String:Any]]) {
        
        var dlbarr : [OverlayButton] = []
        for item in result {
            
            let boundaries = item["boundingBox"] as! [String : Any]
            let y = boundaries["top"] as! Int
            let x = boundaries["left"] as! Int
            let width = boundaries["width"] as! Int
            let height = boundaries["height"] as! Int
            let price = item["price"] as! Double
            
            let offset_x: Double = 19.0
            let offset_y: Double = 93.0
            
            // scale item
            let yscaled = Double(y) / ImgurUpload.mult
            let xscaled = Double(x) / ImgurUpload.mult
            let heightScaled = Double(height) / ImgurUpload.mult
            let widthScaled = Double(width) / ImgurUpload.mult
            
            // get center of item
            let x_center = xscaled + (widthScaled / 2)
            let y_center = yscaled + (heightScaled / 2)
            
            // apply offset
            let yoffset = yscaled + offset_y
            let xoffset = xscaled + offset_x
            print("a button")
            print(yscaled)
            print(xscaled)
            print(widthScaled)
            print(heightScaled)
            
            let oldFrame = CGRect(x: xoffset, y: yoffset, width: widthScaled, height: heightScaled)
            let dlb = OverlayButton(frame: oldFrame, price: Double(price));
            
            let newWidth = dlb.frame.width + 20
            let newHeight = dlb.frame.height
            let new_x = CGFloat(x_center - Double(newWidth / 2) + offset_x)
            let new_y = CGFloat(y_center - Double(newHeight / 2) + offset_y)
            dlb.frame = CGRect(x: new_x, y: new_y, width: newWidth, height: newHeight)
            
            dlbarr.append(dlb)
            
            
        }
        
        buttons = dlbarr
        
        DispatchQueue.main.async(){
            //code
            
            for buttony in self.buttons {
                self.view.addSubview(buttony)
                buttony.reload()
                buttony.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            }
            
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            
        }
        
        
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        for button in buttons {
            if(button.selecteder) {
                usernameToButtonMap[username!]!.append(button)
            }
        }
        
        
        for button in buttons {
            button.reset()
        }
    }
    
    
    func readReceipt(url: String) -> Void {
        MicrosoftOCR.loadAndParse(imageURL: receiptURL , completion: createOverlayButtons)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.usernames)
        print(self.usernameToButtonMap)
        
        if(segue.identifier == "doneButtonToUsernameVC") {
            let a = segue.destination as! ChooseUsernameViewController
            a.usernameToButtonMap = self.usernameToButtonMap
            a.usernames = self.usernames
            a.receiptImage = self.image!
            a.imageURL = self.receiptURL
        }
        else if(segue.identifier == "backButtonToUsernameVC") {
            print("Getting in now")
            let a = segue.destination as! ChooseUsernameViewController
            a.usernameToButtonMap = self.usernameToButtonMap
            a.usernames = self.usernames
            a.receiptImage = self.image!
            a.imageURL = self.receiptURL
        }
        
    }
}
