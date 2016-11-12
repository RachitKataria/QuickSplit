//
//  ChooseUsernameViewController.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class ChooseUsernameViewController: UIViewController {

    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var chooseUsersLabel: UILabel!
    
    @IBOutlet weak var user1TextField: UITextField!
    @IBOutlet weak var user2TextField: UITextField!
    
    @IBOutlet weak var user3TextField: UITextField!
    @IBOutlet weak var user4TextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addUserButtonClicked(_ sender: Any) {
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
    }
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
