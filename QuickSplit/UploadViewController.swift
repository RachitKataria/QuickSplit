//
//  UploadViewController.swift
//  QuickSplit
//
//  Created by Kelly Lampotang on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var uploadFromCameraRoll: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    var imageURL : String?
    var receiptImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorView.isHidden = true

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
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        vc.sourceType = .camera
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
            self.splitButton.isEnabled = false
        }
        
        // Get the image captured by the UIImagePickerController
        // Do something with the images (based on your use case)
        // Dismiss UIImagePickerController to go back to your original view controller
        self.receiptImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        self.splitButton.isHidden = false
        print("did finish picking image")

        ImgurUpload.upload(image: receiptImage!, completion: {(link: String) -> Void in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
                self.splitButton.isEnabled = true
            }
            self.imageURL = link
        })
        
    }
    
    
    // overridden methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToReceiptView" {
            let csvc = segue.destination as! ChooseUsernameViewController
            csvc.receiptImage = self.receiptImage
            csvc.imageURL = self.imageURL
        }
    }

}
