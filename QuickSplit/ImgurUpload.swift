//
//  ImgurUpload.swift
//  QuickSplit
//
//  Created by Andrew Jiang on 11/13/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

struct ImgurUpload {
    
    static let mult: Double = 1.0
    static let width: Double = 333.0
    static let height: Double = 444.0
    static let quality: Double = 1
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func upload(image: UIImage, completion: @escaping (_ result: String) -> Void = {_ in }) {
        // compress image for fast upload
        let resizedImage = resizeImage(image: image, newWidth: CGFloat(width))
        let data = UIImageJPEGRepresentation(resizedImage, CGFloat(quality))
        
        // imgur key
        let clientID = "e452e17ad759f66"
        
        var request = URLRequest(url: URL(string: "https://api.imgur.com/3/image")!)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                print(link) // got the link back!
                
                completion(link) // CALLBACK
            } else {
                print("error converting to json")
            }
            
        }.resume()
    }
}
