//
//  SearchResultsTableViewController.swift
//  Homely
//
//  Created by Madushani Lekam Wasam Liyanage on 1/9/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit
import CoreLocation

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = 100.0
        locMan.distanceFilter = 50.0
        return locMan
    }()
    
    var currentLocation: String?{
        didSet{
            locationManager.stopUpdatingLocation()
            getSeachResults(for: (currentLocation?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!)
        }
    }
    
    let geoCoder: CLGeocoder = CLGeocoder()
    
    var residences: [Residence] = []
    var places: [Place] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        //        APIRequestManager.manager.getData(endPoint: "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&_limit=10&location=charleston%20illinois") { (data: Data?) in
        //            if  let validData = data,
        //                let validResidences = Residence.getResidence(from: validData) {
        //                self.residences = validResidences
        //                DispatchQueue.main.async {
        //                    self.tableView.reloadData()
        //                }
        //            }
        //        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return residences.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCellIdentifier", for: indexPath)
        
        cell.textLabel?.text = residences[indexPath.row].name
        cell.detailTextLabel?.text = residences[indexPath.row].address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigationController != nil{
            let residenceVC = ResidenceViewController()
            residenceVC.residence = residences[indexPath.row]
            residenceVC.title = residences[indexPath.row].name
            navigationController?.pushViewController(residenceVC, animated: true)
        }
    }
    
    // MARK: - CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("All good")
            manager.startUpdatingLocation()
            //      manager.startMonitoringSignificantLocationChanges()
            
        case .denied, .restricted:
            print("NOPE")
            
        case .notDetermined:
            print("IDK")
            locationManager.requestAlwaysAuthorization()
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Oh woah, locations updated")
        //    dump(locations)
        
        guard let validLocation: CLLocation = locations.last else { return }
        
        geoCoder.reverseGeocodeLocation(validLocation) { (placemarks, error: Error?) in
            
            if error != nil{
                dump(error)
            }
            
            guard let validPlaceMarks: [CLPlacemark] = placemarks,
                let validPlace: CLPlacemark = validPlaceMarks.last else {return}
            print(validPlace.locality!)
            self.currentLocation = validPlace.locality
            
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //
    //        if segue.identifier == "showResults"{
    //            if let placeVC = segue.destination as? PlaceTableViewController{
    //                if let index = tableView.indexPathForSelectedRow{
    //                    placeVC.residence = residences[index.row]
    //
    //                }
    //            }
    //
    //        }
    //    }
    
    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else { return }
        
        guard let percentEncodedLocation = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        getSeachResults(for:percentEncodedLocation)
        
    }
    
    func getSeachResults(for location: String){
        
        let endpoint: String = "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&_limit=10&location=\(location)"
        
        APIRequestManager.manager.getData(endPoint: endpoint) { (data: Data?) in
            
            guard let validData = data,
                let newValidResidences = Residence.getResidence(from: validData) else { return }
            
            DispatchQueue.main.async {
                self.residences = newValidResidences
                self.tableView.reloadData()
                
            }
        }
        self.savingSearchResults("text")
    }
    
    // MARK: - User Defaults
    
    func savingSearchResults(_ result: String) {
        var array = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        
        guard !array.contains(result) else { return }
        array.append(result)
        defaults.set(array, forKey: "SavedArray")
        defaults.synchronize()
    }
    
}
