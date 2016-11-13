//
//  MicrosoftOCR.swift
//  QuickSplit
//
//  Created by Andrew Jiang on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

//: Playground - noun: a place where people can play

import UIKit

struct MicrosoftOCR {
    func loadMicrosoftComputerVisionOCRData(imageURL:String, completion: @escaping (_ result: [String:Any]) -> Void = {_ in }) {
        // define request parameters
        let requestURL = "https://api.projectoxford.ai/vision/v1.0/ocr"
        let subscriptionKey = "85d0480addf8496aa398907299eb56af"
        let jsonString = "{\"url\":\"" + imageURL + "\"}"
        
        
        // configure request
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = "POST"
        request.httpBody = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("85d0480addf8496aa398907299eb56af", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        // set up & run request task
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            print("YO")
            // check for fundamental networking error
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] {
                
                let language = responseDict["language"] as! String
                let textAngle = responseDict["textAngle"] as! Int
                let orientation = responseDict["orientation"] as! String
                var regions = responseDict["regions"] as! [[String:Any]]
                
                // defines bounding box normalization from string to {left, top, width, height}
                func normalizeBoundingBox(boundingBox:String) -> [String:Int] {
                    let boundingBoxArray = boundingBox.characters.split{$0 == ","}.map(String.init)
                    let boundingBoxDict:[String:Int] = [
                        "left": Int(boundingBoxArray[0])!,
                        "top": Int(boundingBoxArray[1])!,
                        "width": Int(boundingBoxArray[2])!,
                        "height": Int(boundingBoxArray[3])!
                    ]
                    
                    return boundingBoxDict
                }
                
                // map regions
                regions = regions.map({ (region) -> [String:Any] in
                    let boundingBox = normalizeBoundingBox(boundingBox: region["boundingBox"] as! String)
                    var lines = region["lines"] as! [[String:Any]]
                    
                    // map lines
                    lines = lines.map({ (line) -> [String:Any] in
                        let boundingBox = normalizeBoundingBox(boundingBox: line["boundingBox"] as! String)
                        var words = line["words"] as! [[String:Any]]
                        
                        // map words
                        words = words.map({ (word) -> [String:Any] in
                            
                            let boundingBox = normalizeBoundingBox(boundingBox: word["boundingBox"]! as! String)
                            let text = word["text"]!
                            
                            return [
                                "boundingBox": boundingBox,
                                "text": text
                            ]
                        })
                        
                        return [
                            "boundingBox": boundingBox,
                            "words": words
                        ]
                    })
                    
                    return [
                        "boundingBox": boundingBox,
                        "lines": lines
                    ]
                    
                })
                
                let result: [String:Any] = [
                    "language": language,
                    "textAngle": textAngle,
                    "orientation": orientation,
                    "regions": regions
                ]
                
                completion(result)
            }
            
            // end of task
            }.resume()
    }
    
    func loadAndParse(imageURL:String, completion: @escaping (_ result: [[String:Any]]) -> Void = {_ in }) {
        loadMicrosoftComputerVisionOCRData(imageURL: imageURL, completion: { (result: [String:Any]) -> Void in
            
            var toRet: [[String:Any]] = []
            
            for region: [String:Any] in (result["regions"] as! [[String:Any]]) {
                for line: [String:Any] in (region["lines"] as! [[String:Any]]) {
                    for word: [String:Any] in (line["words"] as! [[String:Any]]) {
                        let wordText: String = (word["text"] as! String).replacingOccurrences(of: "$", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "so", with: "0").replacingOccurrences(of: "o", with: "0")
                        if (wordText).range(of:".") != nil {
                            let parsedFloat = Float(wordText) ?? 0
                            if parsedFloat != 0 {
                                toRet.append([
                                    "boundingBox": word["boundingBox"]!,
                                    "price": parsedFloat
                                    ])
                            }
                        }
                    }
                }
            }
            
            completion(toRet)
            
        })
    }
}

