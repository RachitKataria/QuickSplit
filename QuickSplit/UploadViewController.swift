//
//  UploadViewController.swift
//  QuickSplit
//
//  Created by Kelly Lampotang on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadFromCameraRoll: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    var receiptImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

//        splitButton.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func uploadFromCameraRollClicked(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        vc.sourceType = .photoLibrary
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func splitClicked(_ sender: Any) {
        print("split")
    }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = false
            vc.sourceType = .camera
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else {
            noCamera()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.receiptImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        print("picked")
        self.dismiss(animated: true, completion: nil)

        DispatchQueue.main.async {
            print(Thread.isMainThread)
            self.performSegue(withIdentifier: "pls", sender: self)
        }
        
    }
    
    
    // overridden methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pls" {
            print("entered")
            let csvc = segue.destination as! ChooseUsernameViewController
            csvc.receiptImage = self.receiptImage
            print("finished")
        }
    }
    func noCamera() {
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
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
