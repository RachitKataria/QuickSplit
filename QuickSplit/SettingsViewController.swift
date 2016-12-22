//
//  SettingsViewController.swift
//  QuickSplit
//
//  Created by Kelly Lampotang on 12/22/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var searchTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: have the selected segment index be whatever was last used (use nsuserdefaults)
        
        if(segmentedControl.selectedSegmentIndex == 0) {
            searchTableView.isHidden = true
            searchTextField.isHidden = true
            
            //TODO: Current City label should display current city
            
        }
        else {
            searchTableView.isHidden = false
            searchTextField.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func segControlValueChanged(_ sender: Any) {
        if(segmentedControl.selectedSegmentIndex == 0) { //Current city
            searchTableView.isHidden = true
            searchTextField.isHidden = true
            //Current City label should display current city
            
        }
        else { //Search for a city
            searchTableView.isHidden = false
            searchTextField.isHidden = false
        }

    }
   

}
