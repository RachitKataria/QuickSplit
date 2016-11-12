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
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageReceipt: UIImageView!
    var receiptImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        splitButton.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func uploadFromCameraRollClicked(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(vc, animated: true, completion: nil)

    }
    @IBAction func splitClicked(_ sender: Any) {
        
        print("split")
    }
    @IBAction func uploadButtonClicked(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        // Dismiss UIImagePickerController to go back to your original view controller
        imageReceipt.image = editedImage
        imageReceipt.isHidden = false
        self.view.addSubview(imageReceipt)
        self.receiptImage = editedImage
        dismiss(animated: true, completion: nil)
        self.splitButton.isHidden = false
        print("did finish")

    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToReceiptView")
        {
            let csvc = segue.destination as! ChooseUsernameViewController
            csvc.receiptImage = self.receiptImage
        }
    }

}
