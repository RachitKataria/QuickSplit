//
//  ViewController.swift
//  QuickSplit
//
//  Created by Rachit K on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let price = 10.0;
        let frame = CGRect(x: 30, y: 20, width: 50, height: 50)
        let button = DeepLinkButton(frame: frame, price: price)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setTitle("Test", for: .normal)
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonAction(sender: DeepLinkButton!) {
        print("touched me")
        print(sender.price)
    }


}

