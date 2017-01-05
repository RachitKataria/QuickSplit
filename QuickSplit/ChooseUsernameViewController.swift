//
//  ChooseUsernameViewController.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class ChooseUsernameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Tax/tip options outlets
    @IBOutlet weak var changeTaxRatePromptLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxCheckbox: UIButton!
    @IBOutlet weak var tipCheckbox: UIButton!
    //tax/tip options variables
    var clickedTip = false
    var clickedTax = false
    var newTipField: UITextField?
    var tipAmount:Double = 0.0
    var taxAmount:Double = 0.0

    
    @IBOutlet weak var chooseUsersLabel: UILabel!
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var chargeButton: UIButton!
    
    @IBOutlet weak var uploadingImageLabel: UILabel!
    @IBOutlet weak var loadingImageActivityIndicator: UIActivityIndicatorView!
    
    var receiptImage : UIImage?
    var imageURL : String?
    var numUsernames:Int = 1;
    var usernames: [String] = []
    
    // Tip and Tax
    
    
    var usernameToButtonMap: [String:[OverlayButton]] = [:]
    var users: [User] = []
    
    var buttonYToCountMap: [CGFloat:Int] = [:]
    
    
    weak var addAlertAction: UIAlertAction?
    
    @IBOutlet weak var usernameTableView: UITableView!
    
    override func viewDidLoad() {
        print("entered view did load")
        super.viewDidLoad()
        
        if(usernames.count == 0 || self.imageURL == nil) {
            chargeButton.isEnabled = false;
        }
        
        if(self.imageURL == nil) {
            
            ImgurUpload.upload(image: receiptImage!, completion: {(link: String) -> Void in
                self.imageURL = link
                DispatchQueue.main.async {
                    self.addUserButton.isEnabled = true
                    self.loadingImageActivityIndicator.isHidden = true
                    self.uploadingImageLabel.isHidden = true
                    if(self.usernames.count != 0) {
                        self.chargeButton.isEnabled = true;
                    }
                }
            })
        }
        
        // table view delegate data source (init)
        usernameTableView.delegate = self
        usernameTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.usernameTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        if(self.imageURL == nil) {
            self.addUserButton.isEnabled = false
            self.loadingImageActivityIndicator.startAnimating()
        }
        else {
            self.loadingImageActivityIndicator.isHidden = true
            self.uploadingImageLabel.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Tax/tip actions:
    
    @IBAction func tipToggled(_ sender: Any) {
    }
    @IBAction func taxToggled(_ sender: Any) {
    }
    @IBAction func changeTaxRateTapped(_ sender: Any) {
    }
    
    
    
    
    @IBAction func addUserButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Venmo Username", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleTextFieldTextDidChangeNotification), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
            
            textField.placeholder = "John Doe"
        }
        
        
        addAlertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let firstTextField = alert.textFields![0] as UITextField
            let text = firstTextField.text
            self.usernames.append(text!)
            
            self.usernameToButtonMap[text!] = []
            self.usernameTableView.reloadData()
            
            if(self.usernames.count > 0) {
                self.chargeButton.isEnabled = true
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            return
        }
        
        alert.addAction(addAlertAction!)
        addAlertAction?.isEnabled = false
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func clickedChargeButton(_ sender: Any) {
        
        var price: Double = 0
        
        var tipChecked: Bool
        var taxChecked: Bool
        
        //Putting this here for now:
        //TODO - check later
        tipChecked = false
        taxChecked = false
        for username in usernameToButtonMap.keys {
            for button in usernameToButtonMap[username]! {
                if(buttonYToCountMap[button.frame.minY] == nil) {
                    buttonYToCountMap[button.frame.minY] = 1
                }
                else {
                    buttonYToCountMap[button.frame.minY]! += 1
                }
            }
        }
        
        for username in usernameToButtonMap.keys {
            price = 0;
            
            for button in usernameToButtonMap[username]! {
                if(buttonYToCountMap[button.frame.minY] != nil) {
                    price += button.getPrice() / Double(buttonYToCountMap[button.frame.minY]!)
                }
            }
            
            // Tax and tip calculation logic
            if(taxChecked) {
                price += ((taxAmount / 100) * price)
            }
            if (tipChecked) {
                price += (tipAmount / Double(usernameToButtonMap.count))
            }
            
            let user = User(usrname: username, price: price)
            users.append(user)
        }
        
        
        
        performSegue(withIdentifier: "showVenmoVC", sender: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToChooseItemView")
        {
            let csvc = segue.destination as! ChooseItemViewController
            csvc.image = self.receiptImage!
            csvc.receiptURL = self.imageURL!
            csvc.username = usernames[self.usernameTableView.indexPathForSelectedRow!.row]
            csvc.usernameToButtonMap = self.usernameToButtonMap
            csvc.usernames = self.usernames
        }
        else if(segue.identifier == "showVenmoVC") {
            let a = segue.destination as! Checkout2ViewController
            a.arrayUsers = users
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsernameCell", for: indexPath) as! UsernameTableViewCell
        cell.usernameLabel.text = usernames[indexPath.row]
        cell.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        cell.usernameLabel.textColor = UIColor.white
        return cell
    }
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        addAlertAction!.isEnabled = (textField.text != "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToChooseItemView", sender: nil)
    }
    
    
}
