//
//  ViewController.swift
//  LocationTracker
//
//  Created by KeshanWithanage on 21/5/19.
//  Copyright © 2019 KeshanWithanage. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lat: UITextField!
    @IBOutlet weak var long: UITextField!
    @IBOutlet weak var activityIn: UIActivityIndicatorView!
    
    
    var locations = [mapLocation]()
    var filterArr = [mapLocation]()
    let query = QueryResults()
    var sortArr = [mapLocation]()
    var distance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIn.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIn.startAnimating()
        parseJSONOnline()
        getCurrentLocation()

    }
    
    func getCurrentLocation(){ // Impor
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        var latitude: Double? {
            if let val = lat.text {
                return Double(val)
            } else {
                return nil
            }
        }
        
        var longitude: Double? {
            if let text = long.text {
                return Double(text)
            } else {
                return nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.lat.text = "\(location.coordinate.latitude)"
            self.long.text = "\(location.coordinate.longitude)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            DisableLocation()
        }
    }
    
    func DisableLocation() {
        let alertController = UIAlertController(title: "Location Access Denied",
                                                message: "Please enable your location services.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if URL(string: UIApplication.openSettingsURLString) != nil {
                print("Open Settings Clicked")
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sortView( latt : String, longg : String){
        
        let latitude = (latt as NSString).doubleValue
        let longitudee = (longg as NSString).doubleValue
        let LocationAtual: CLLocation = CLLocation(latitude: latitude, longitude: longitudee)
        locations.sort(by: { $0.distance(to: LocationAtual) < $1.distance(to: LocationAtual) })
        tableView.reloadData()
        
    }
    
    func grabit() {

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation();
        print(self.lat.text ?? 0)
        print(self.long.text ?? 0
        
        
        )
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var place: mapLocation
        place = locations[indexPath.row]
        cell.textLabel!.text = "Marker ID " + place.stMarkerID + "  Bay ID " + place.bayID
        cell.detailTextLabel!.text = "Lat " + place.lat + "  Long " + place.lon
        return cell
    }

    @IBAction func sortNearbyClicked(_ sender: Any) {
        sortView(latt: self.lat.text!, longg: self.long.text!)
    }
    
    @IBAction func getCurrLocClicked(_ sender: Any) {
        getCurrentLocation()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    func parseJSONOnline()
    {
        
        
        query.parseJSONOnline() { results in
            if let results = results {
                self.locations = results
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
                
            }
            
            self.activityIn.stopAnimating()
        }
        
    }
    
    }



