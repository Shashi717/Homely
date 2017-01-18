//
//  MapViewController.swift
//  Homely
//
//  Created by Jermaine Kelly on 1/10/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    private var places: [Place] = []
    private var backButton: UIButton = UIButton()
    var residence: Residence!{
        didSet{
            //location = CLLocation(latitude: residence.latitude, longitude: residence.longitude)
            addPin(at: residence.name, lat: residence.latitude, long: residence.longitude)
            fetchNearByPlaces()
        }
    }
    private let mapView:MKMapView = {
        let mapView = MKMapView()
        mapView.mapType  = .standard
        mapView.isZoomEnabled = true
        mapView.showsPointsOfInterest = false
        return mapView
    }()
    private var centerButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 10.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
    }
    
    func addPin(at name: String, lat: Double, long: Double){
        let pinlocation = CLLocation(latitude: lat, longitude: long)
        let pinAnnotation: MKPointAnnotation = MKPointAnnotation()
        pinAnnotation.title = name
        //pinAnnotation.subtitle = "Hello Subtitle"
        pinAnnotation.coordinate = pinlocation.coordinate
        mapView.addAnnotation(pinAnnotation)
    }
    
    func addResidentPin(){
        let pinlocation = CLLocation(latitude: residence.latitude, longitude: residence.longitude)
        let pinAnnotation: MKPointAnnotation = MKPointAnnotation()
        //let pinAnnotationVieq: MKPinAnnotationView = MKPinAnnotationView()
        
        pinAnnotation.title = residence.name
        //pinAnnotation.subtitle = "Hello Subtitle"
        pinAnnotation.coordinate = pinlocation.coordinate
        mapView.addAnnotation(pinAnnotation)
    }
    
    func fetchNearByPlaces(){
        APIRequestManager.manager.getData(endPoint: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(self.residence.latitude),\(self.residence.longitude)&radius=500&key=AIzaSyCBb_tIlTkF4FaLXdCe9qISjOpYZl-fCCs") { (data) in
            self.places = Place.makePlaceObj(from: data!)
            //dump(self.places)
            self.addNearByPlacesPins()
        }
    }
    
    func addNearByPlacesPins(){
        for place in places{
            addPin(at: place.name, lat: place.latitude!, long: place.longitude!)
        }
        centerHomeInMap()
    }
    
    func centerHomeInMap(){
        let residencelocation = CLLocation(latitude: residence.latitude, longitude: residence.longitude)
        let mkRegion = MKCoordinateRegionMakeWithDistance(residencelocation.coordinate, 1000.0, 1000.0)
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: residence.latitude, longitude: residence.longitude), animated: true)
        DispatchQueue.main.async {
            self.mapView.setRegion(mkRegion, animated: true)
        }
    }
    
    func addViews(){
        
        self.view.addSubview(mapView)
        self.view.addSubview(centerButton)
        self.view.addSubview(backButton)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        centerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //centerButton.setTitle("Center Residence", for: .normal)
        centerButton.backgroundColor = .white
        
        centerButton.setBackgroundImage(UIImage(named: "mapHome"), for: .normal)
        centerButton.addTarget(self, action: #selector(centerHomeInMap), for: .touchUpInside)
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.setBackgroundImage(UIImage(named: "close"), for: .normal)
        //backButton.setTitle("back", for: .normal)
        backButton.addTarget(self, action: #selector(closeMapView), for: .touchUpInside)
    }
    
    func closeMapView(){
        dismiss(animated: true, completion: nil)
    }
}
