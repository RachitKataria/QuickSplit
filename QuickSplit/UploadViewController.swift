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
    var imageURL : String?
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
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        vc.sourceType = .camera
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        activityIndicatorView.startAnimating()
        uploadButton.isEnabled = false
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Do something with the images (based on your use case)
        // Dismiss UIImagePickerController to go back to your original view controller
        imageReceipt.image = editedImage
        imageReceipt.isHidden = false
        self.view.addSubview(imageReceipt)
        self.receiptImage = editedImage
        dismiss(animated: true, completion: nil)
        self.splitButton.isHidden = false
        print("did finish")
        let data = UIImageJPEGRepresentation(receiptImage!, 0.1)
        
        var request = URLRequest(url: URL(string: "https://api.imgur.com/3/image")!)
        request.httpMethod = "POST"
        request.httpBody = data
        
        let clientID = "e452e17ad759f66"
        
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                print(responseDictionary)
                let data1 = responseDictionary["data"] as! NSDictionary
                let link = data1["link"] as! String
                print(link)
                activityIndicatorView.startAnimating()
                uploadButton.isEnabled = true
                self.imageURL = link
            } else
            {
                print("error converting to json")
            }
            
        }
        task.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToReceiptView")
        {
            let csvc = segue.destination as! ChooseUsernameViewController
            csvc.receiptImage = self.receiptImage
            csvc.imageURL = self.imageURL
        }
    }

}
