//
//  SettingsViewController.swift
//  QuickSplit
//
//  Created by Kelly Lampotang on 12/22/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var taxPercentageLabel: UILabel!

    let locationManager = CLLocationManager()
    let API_KEY = "AIzaSyDl7xbKCu609eOsFo4zMsfWGnU5Tk_45OY"
    var newWordField: UITextField?
    var cityTyped = ""
    var currLocation = ""
    var locationChosen = ""
    var results: NSArray = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //LOAD FROM USER DEFAULTS
        
        let defaults = UserDefaults.standard
        let savedIndex = defaults.integer(forKey: "selectedIndex")
        segmentedControl.selectedSegmentIndex = (savedIndex)
        
        let city = defaults.object(forKey: "city") as? String
        if(city != nil) {
            currentCityLabel.text = city!
        }
        
        //Location setup
        locationManager.delegate = self //sets the class as delegate for locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //specifies the location accuracy
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //starts receiving location updates from CoreLocation
    }


    func fetchCities(query: String) {
        print("google apps api being called")
        let queryString = cityTyped.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(queryString)&types=(cities)&key=\(API_KEY)")
        
        let request = NSURLRequest(url: url! as URL)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    self.results = responseDictionary.value(forKeyPath: "predictions") as! NSArray
                    //print(self.results)
                }
            }
        });
        
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Definition"
        self.newWordField = textField
    }
    func zipEntered(alert: UIAlertAction!){
        // store the new word
        self.currentCityLabel.text = self.newWordField?.text
        
        let defaults = UserDefaults.standard
        defaults.set(self.newWordField?.text, forKey: "city")
        defaults.synchronize()
    }
    @IBAction func segControlValueChanged(_ sender: Any) {
        if(segmentedControl.selectedSegmentIndex == 0) { //Current city
            //Current City label should display current city
            currentCityLabel.text = currLocation
            
        }
        else { //Search for a city
            let newWordPrompt = UIAlertController(title: "Enter zip code", message: "Zip Code", preferredStyle: UIAlertControllerStyle.alert)
            newWordPrompt.addTextField(configurationHandler: addTextField)
            newWordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            newWordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: zipEntered))
            present(newWordPrompt, animated: true, completion: nil)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(segmentedControl.selectedSegmentIndex, forKey: "selectedIndex")
        defaults.synchronize()

    }
    
    //If location manager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    //If location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                if(self.segmentedControl.selectedSegmentIndex == 0) {
                    self.displayLocationInfo(placemark: pm)
                }
                
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    //Print out the location
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            print(containsPlacemark)
            //Pass into global currlat and long variables
            currLocation = ("\((containsPlacemark.postalCode)!), \((containsPlacemark.country)!)")
            print(currLocation)
            currentCityLabel.text = currLocation
            let defaults = UserDefaults.standard
            defaults.set(currLocation, forKey: "city")
            defaults.synchronize()
        }
        
    }
    
    
    
   

}
