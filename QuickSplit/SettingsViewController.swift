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
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var taxPercentageLabel: UILabel!

    let locationManager = CLLocationManager()
    var currLocation = ""
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
        //Location setup
        
        locationManager.delegate = self //sets the class as delegate for locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //specifies the location accuracy
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //starts receiving location updates from CoreLocation
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
                self.displayLocationInfo(placemark: pm)
                
                
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
            
            //Pass into global currlat and long variables
            currLocation = ("\((containsPlacemark.locality)!), \((containsPlacemark.administrativeArea)!)")
            print(currLocation)
            currentCityLabel.text = currLocation
        }
        
    }
   

}
