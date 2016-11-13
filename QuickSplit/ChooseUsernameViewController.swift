//
//  ChooseUsernameViewController.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class ChooseUsernameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chooseUsersLabel: UILabel!
    
    var receiptImage : UIImage?
    var imageURL : String?
    var numUsernames:Int = 1;
    var usernames: [String] = []
    
    var usernameToButtonMap: [String:[OverlayButton]] = [:]
    var users: [User] = []
    
    
    weak var addAlertAction: UIAlertAction?
    
    @IBOutlet weak var usernameTableView: UITableView!
    
    override func viewDidLoad() {
        print("entered view did load")
        super.viewDidLoad()
        
        usernameTableView.delegate = self
        usernameTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.usernameTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        for username in usernameToButtonMap.keys {
            for button in usernameToButtonMap[username]! {
                price += button.getPrice() / Double(button.getCount())
            }
            
            let user = User(usrname: username, price: price)
            users.append(user)
            
            price = 0
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
            csvc.usernames = self.usernames
            csvc.usernameToButtonMap = self.usernameToButtonMap
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
