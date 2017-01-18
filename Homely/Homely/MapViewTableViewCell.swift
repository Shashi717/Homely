//
//  MapViewTestTableViewCell.swift
//  Homely
//
//  Created by Jermaine Kelly on 1/11/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit
import MapKit

class MapViewTableViewCell: UITableViewCell {
    static let identifier: String = "MapViewCell"
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType  = .standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.showsPointsOfInterest = false
        return mapView
    }()
    
    let seeNearByButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Nearby Places", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.shadowRadius = 10.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private var location: CLLocation = CLLocation()
    var residence: Residence!{
        didSet{
            location = CLLocation(latitude: residence.latitude, longitude: residence.longitude)
            addPin()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }

    private func addViews(){
        
        self.addSubview(mapView)
        self.addSubview(seeNearByButton)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        seeNearByButton.translatesAutoresizingMaskIntoConstraints = false
        
        //MapView Constraints
        mapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //Button Constraints
        seeNearByButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -40).isActive = true
        seeNearByButton.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor).isActive = true
        seeNearByButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        seeNearByButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    private func addPin(){
        let pinAnnotation: MKPointAnnotation = MKPointAnnotation()
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0)
        
        pinAnnotation.title = residence.name
        pinAnnotation.subtitle = "$\(residence.pricePerNight)"
        pinAnnotation.coordinate = location.coordinate
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: residence.latitude, longitude: residence.longitude), animated: true)
        mapView.addAnnotation(pinAnnotation)
        
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
}
