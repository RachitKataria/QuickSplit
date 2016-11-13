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
        for a in result {
            
            let boundaries = a["boundingBox"] as! [String:Any]
            let y = boundaries["top"] as! Int
            let x = boundaries["left"] as! Int
            let width = boundaries["width"] as! Int
            let height = boundaries["height"] as! Int
            let price = a["price"] as! Double
            
            //Scale and offset
            let yscaled = Double(y) / ImgurUpload.mult
            let xscaled = Double(x) / ImgurUpload.mult
            let widthScaled = Double(width) / ImgurUpload.mult
            let heightScaled = Double(height) / ImgurUpload.mult
            let yoffset = yscaled + 93
            let xoffset = xscaled + 19
            print("a button")
            print(yscaled)
            print(xscaled)
            print(widthScaled)
            print(heightScaled)
            
            let frame = CGRect(x: xoffset, y: yoffset, width: widthScaled, height: heightScaled)
            
            let dlb = OverlayButton(frame: frame, price: Double(price));
            dlbarr.append(dlb)
            
            
        }
    
        buttons = dlbarr

        DispatchQueue.main.async(){
            //code
            
            for buttony in self.buttons {
                self.view.addSubview(buttony)
                buttony.alpha = 0.4
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
