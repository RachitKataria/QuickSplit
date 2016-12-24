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
    var image: UIImage?
    
    var usernameToButtonMap: [String:[OverlayButton]] = [:]
    var buttons : [OverlayButton] = []
    var username: String?
    var usernames: [String]!
    
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
        
        // do shit to imageview
        receiptImageView.layer.masksToBounds = false
        receiptImageView.clipsToBounds = true
        receiptImageView.layer.cornerRadius = 5
        receiptImageView.layer.borderWidth = 2
        receiptImageView.layer.borderColor = UIColor(red: 0.0, green:0.0, blue:0.0, alpha: 0.5).cgColor
        
        receiptImageView.layer.shadowPath = UIBezierPath(rect: receiptImageView.bounds).cgPath
        
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
            
            let offset_x = receiptImageView.frame.origin.x
            let offset_y = receiptImageView.frame.origin.y
            
            // scale item
            let yscaled = CGFloat(Double(y) / ImgurUpload.mult)
            let xscaled = CGFloat(Double(x) / ImgurUpload.mult)
            let heightScaled = CGFloat(Double(height) / ImgurUpload.mult)
            let widthScaled = CGFloat(Double(width) / ImgurUpload.mult)
            
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
            let new_x = CGFloat(x_center - (newWidth / 2) + offset_x)
            let new_y = CGFloat(y_center - (newHeight / 2) + offset_y)
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
        print(self.usernameToButtonMap)
        
        if(segue.identifier == "doneButtonToUsernameVC" || segue.identifier == "backButtonToUsernameVC") {
            let a = segue.destination as! ChooseUsernameViewController
            a.usernameToButtonMap = self.usernameToButtonMap
            a.receiptImage = self.image!
            a.imageURL = self.receiptURL
            a.usernames = self.usernames
        }
    }
}
