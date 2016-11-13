//
//  ChooseUsernameViewController.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class ChooseUsernameViewController: UIViewController {

    @IBOutlet weak var chooseUsersLabel: UILabel!
    
    @IBOutlet weak var user1TextField: UITextField!
    @IBOutlet weak var user2TextField: UITextField!
    @IBOutlet weak var user3TextField: UITextField!
    @IBOutlet weak var user4TextField: UITextField!
    
    var receiptImage : UIImage?
    var imageURL : String?
    var numUsernames:Int = 1;
    var usernames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user2TextField.alpha = 0;
        user2TextField.isEnabled = false
        
        user3TextField.alpha = 0;
        user3TextField.isEnabled = false
        
        user4TextField.alpha = 0;
        user4TextField.isEnabled = false
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUserButtonClicked(_ sender: Any) {
        if(numUsernames == 1) {
            user2TextField.alpha = 1;
            user2TextField.isEnabled = true
        }
        else if(numUsernames == 2) {
            user3TextField.alpha = 1;
            user3TextField.isEnabled = true
        }
        else if(numUsernames == 3) {
            user4TextField.alpha = 1;
            user4TextField.isEnabled = true
        }
        
        numUsernames += 1
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        let textfields: [UITextField] = [user1TextField, user2TextField, user3TextField, user4TextField]

        
        for textfield in textfields {
            if(textfield.isEnabled) {
                usernames.insert(textfield.text!, at: usernames.count)
            }
        }
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
            csvc.usernames = self.usernames
        }
    }

}
