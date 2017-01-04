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
    var clicked = false
    var clickedTax = false
    var newTipField: UITextField?
    var tipAmount = 0
    var taxAmount = 0
    @IBOutlet weak var buttonTip: UIButton!
    @IBOutlet weak var buttonTax: UIButton!
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var taxPromptLabel: UILabel!
    @IBOutlet weak var changePercentagePromptLabel: UILabel!
    
    @IBAction func toggleTax(_ sender: Any) {
        clickedTax = !clickedTax
        if(clickedTax == true) {
            let imageChecked = UIImage(named: "CheckedBox")
            buttonTax.setImage(imageChecked, for: .normal)
            //buttonTax.imageView?.image = UIImage(named: "CheckedBox")
            let defaults = UserDefaults.standard
            taxAmount = defaults.integer(forKey: "taxPercentage")
            
            //Change label to display this taxAmount:
            taxPromptLabel.text = "Applying \(taxAmount) to each user's portion.)"
            changePercentagePromptLabel.isHidden = false
        }
        else {
            let imageUnchecked = UIImage(named: "UncheckedBox")
            buttonTax.setImage(imageUnchecked, for: .normal)
            taxAmount = 0
            taxPromptLabel.text = "Apply tax to each user's portion?"
            changePercentagePromptLabel.isHidden = true
        }
    }
    @IBAction func percentageTappedToChange(_ sender: Any) {
        //TODO:
        //Bring up alertview
        
        //Save the entered value into a variable
        
        //Change the label to show what will be applied
        
        //Save in user defaults
    }
    @IBAction func clickButton(_ sender: Any) {
        clicked = !clicked
        if(clicked == true) {

            //Bring up alert view
            let newTipAmount = UIAlertController(title: "Enter Tip Percentage", message: "Example: Enter 15 for 15%", preferredStyle: UIAlertControllerStyle.alert)
            newTipAmount.addTextField(configurationHandler: addTextField)
            newTipAmount.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            newTipAmount.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: tipEntered))
            present(newTipAmount, animated: true, completion: nil)
        }
        else {
            //use the filled checkbox symbol
            let imageUnchecked = UIImage(named: "UncheckedBox")
            buttonTip.setImage(imageUnchecked, for: .normal)
            tipAmount = 0
        }
    }
    
    func tipEntered(alert: UIAlertAction!){
        // store the new word
        if(Int((newTipField?.text)!) != nil) {
            //Use the empty checkbox symbol
            let imageChecked = UIImage(named: "CheckedBox")
            buttonTip.setImage(imageChecked, for: .normal)
            tipAmount = Int((newTipField?.text)!)!
        }
        else {
                let alertVC = UIAlertController(
                    title: "Invalid Amount Entered",
                    message: "",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                present(
                    alertVC,
                    animated: true,
                    completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        changePercentagePromptLabel.isHidden = true
        activityIndicator.startAnimating()
        
        receiptImageView.image = self.image
        //do call with the url
        
        usernameLabel.text = username!
        
        readReceipt(url: receiptURL)
        
        // do shit to imageview
        receiptImageView.layer.masksToBounds = false
        receiptImageView.clipsToBounds = true
        receiptImageView.layer.cornerRadius = 5
        receiptImageView.layer.borderWidth = 2
        receiptImageView.layer.borderColor = UIColor(red: 0.0, green:0.0, blue:0.0, alpha: 0.5).cgColor
        
        receiptImageView.layer.shadowPath = UIBezierPath(rect: receiptImageView.bounds).cgPath
        
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Definition"
        self.newTipField = textField
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
