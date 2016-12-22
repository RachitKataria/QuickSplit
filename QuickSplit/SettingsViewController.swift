//
//  SettingsViewController.swift
//  QuickSplit
//
//  Created by Kelly Lampotang on 12/22/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var taxPercentageLabel: UILabel!

    let locationManager = CLLocationManager()
    let API_KEY = "AIzaSyDl7xbKCu609eOsFo4zMsfWGnU5Tk_45OY"
    
    var cityTyped = ""
    var currLocation = ""
    var locationChosen = ""
    var results: NSArray = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        
        //TODO: have the selected segment index be whatever was last used (use nsuserdefaults)
        
        if(segmentedControl.selectedSegmentIndex == 0) {
            searchBar.isHidden = true
            searchBar.isHidden = true
            
            //TODO: Current City label should display current city
            
        }
        else {
            searchTableView.isHidden = false
            searchBar.isHidden = false
        }
        
        
        //Location setup
        
        locationManager.delegate = self //sets the class as delegate for locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //specifies the location accuracy
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //starts receiving location updates from CoreLocation
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        cityTyped = newText
        fetchCities(query: cityTyped)
        
        return true
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
                    self.searchTableView.reloadData()
                }
            }
        });
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchTableViewCell
        cell.backgroundColor = UIColor.clear 
        cell.searchResultLabel.text = (((results[indexPath.row]) as! NSDictionary).value(forKey: "description") as? String)!
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count 
    }
    

    @IBAction func segControlValueChanged(_ sender: Any) {
        if(segmentedControl.selectedSegmentIndex == 0) { //Current city
            searchTableView.isHidden = true
            searchBar.isHidden = true
            //Current City label should display current city
            
        }
        else { //Search for a city
            currentCityLabel.text = ""
            searchTableView.isHidden = false
            searchBar.isHidden = false
        }

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        locationChosen = (((results[indexPath.row]) as! NSDictionary).value(forKey: "description") as? String)!
        print(locationChosen)
        currentCityLabel.text = locationChosen
    }
   

}
