//
//  ResidenceViewController.swift
//  Homely
//
//  Created by Jermaine Kelly on 1/10/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ResidenceViewController: UIViewController {
    var location: CLLocation = CLLocation()
    var places: [Place] = []
    let tableView: UITableView = UITableView()
    let showNearByButton: UIButton = UIButton()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType  = .standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        return mapView
    }()
    
    var residence: Residence!{
        didSet{
            location = CLLocation(latitude: residence.latitude, longitude: residence.longitude)
            addPin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setUpViewHirachy()
        fetchNearByPlaces()
    }
    
    func setUpViewHirachy(){
        self.view.addSubview(mapView)
        self.view.addSubview(showNearByButton)
        
        showNearByButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpViews()
    }
    
    func setUpViews(){
        //        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        tableView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        showNearByButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20).isActive = true
        showNearByButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showNearByButton.setTitle("Show nearby results", for: .normal)
        showNearByButton.setTitleColor(.red, for: .normal)
        showNearByButton.addTarget(self, action: #selector(showAllResults), for: .touchUpInside)
        
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func addPin(){
        let pinAnnotation: MKPointAnnotation = MKPointAnnotation()
        pinAnnotation.title = residence.name
        //pinAnnotation.subtitle = "Hello Subtitle"
        pinAnnotation.coordinate = location.coordinate
        mapView.setCenter(CLLocationCoordinate2D(latitude: residence.latitude, longitude: residence.longitude), animated: true)
        mapView.addAnnotation(pinAnnotation)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0), animated: true)
    }
    
    func showAllResults(){
        if navigationController != nil{
            let mapVC = MapViewController()
            mapVC.residence = residence
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    func fetchNearByPlaces(){
        APIRequestManager.manager.getData(endPoint: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(self.residence.latitude),\(self.residence.longitude)&radius=500&type=food&key=AIzaSyCBb_tIlTkF4FaLXdCe9qISjOpYZl-fCCs") { (data) in
            self.places = Place.makePlaceObj(from: data!)
            
        }
        
    }
}
