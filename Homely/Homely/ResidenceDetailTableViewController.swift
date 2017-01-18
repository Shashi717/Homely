//
//  ResidenceDetailTableViewController.swift
//  Homely
//
//  Created by Madushani Lekam Wasam Liyanage on 1/11/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit
import expanding_collection

class ResidenceDetailTableViewController: ExpandingTableViewController {
    
    fileprivate var scrollOffsetY: CGFloat = 0
    
    let reuseIdentifier = "mapViewIdentifier"
    var selectedResidence: Residence?{
        didSet{
            fillArray()
        }
    }
    
    var selectedImage: UIImage?
    var detailArr: [(key:String,value:Any)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerHeight = 236
     
        tableView.backgroundView = UIImageView(image: UIImage(named:"HomelyBack"))
        
        if navigationController != nil{
            self.navigationController?.isNavigationBarHidden = false
        }
        
        self.tableView.separatorStyle = .none

        self.tableView.register(MapViewTableViewCell.self, forCellReuseIdentifier: MapViewTableViewCell.identifier)
        
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    @IBAction func bookNowButtonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "airbnbWebviewSegueIdentifier", sender: self)
        
    }
    
    func fillArray() {
        
        if let city = selectedResidence?.city,
            let address = selectedResidence?.address,
            let bedrooms = selectedResidence?.bedrooms,
            let beds = selectedResidence?.beds,
            let personCapacity = selectedResidence?.personCapacity,
            let currency = selectedResidence?.currency,
            let price = selectedResidence?.pricePerNight,
            let hostName = selectedResidence?.hostName,
            let rating = selectedResidence?.rating,
            let bathrooms = selectedResidence?.bathrooms {
            detailArr.append(("City", city))
            detailArr.append(("Bedrooms", String(bedrooms)))
            detailArr.append(("Beds", String(beds)))
            detailArr.append(("Person Capacity", String(personCapacity)))
            detailArr.append(("Bathrooms", bathrooms))
            detailArr.append(("Address", address))
            detailArr.append(("Price", "\(currency) \(price) / Night"))
            detailArr.append(("Host Name", hostName))
            detailArr.append(("Rating", rating))
            detailArr.append(("Map", ""))
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return detailArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellToReturn = UITableViewCell()
        
        switch indexPath.row{
            
        case detailArr.count - 1:
            let mapCell = tableView.dequeueReusableCell(withIdentifier: MapViewTableViewCell.identifier, for: indexPath) as! MapViewTableViewCell
            mapCell.residence = selectedResidence
            mapCell.seeNearByButton.addTarget(self, action: #selector(showNearByResultsMap), for: .touchUpInside)
            cellToReturn = mapCell
            
        default:
            let detailsCell = tableView.dequeueReusableCell(withIdentifier: "detailCellIdentifier", for: indexPath) as! ResidenceDetailTableViewCell
            detailsCell.detailLabel.text = "\(detailArr[indexPath.row].key): \(detailArr[indexPath.row].value) "
            cellToReturn = detailsCell
            
        }
        return cellToReturn
    }
    
}

extension ResidenceDetailTableViewController {
    
    @IBAction func exitButtonHandler(_ sender: AnyObject) {
        // buttonAnimation
        let viewControllers: [SearchResultsViewController?] = navigationController?.viewControllers.map { $0 as? SearchResultsViewController } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
    
    func showNearByResultsMap(){
        let mapVC: MapViewController = MapViewController()
        mapVC.residence = selectedResidence
        present(mapVC, animated: true, completion: nil)
    }
    
}

// MARK: UIScrollViewDelegate

extension ResidenceDetailTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //            if scrollView.contentOffset.y < -25 {
        //              // buttonAnimation
        //              let viewControllers: [SearchResultsViewController?] = navigationController?.viewControllers.map { $0 as? SearchResultsViewController } ?? []
        //
        //              for viewController in viewControllers {
        //                if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
        //                  rightButton.animationSelected(false)
        //                }
        //              }
        //              popTransitionAnimation()
        //            }
        
        scrollOffsetY = scrollView.contentOffset.y
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "airbnbWebviewSegueIdentifier" {
            if let awvc = segue.destination as? AirbnbWebViewController {
                let airbnbURL = "https://www.airbnb.com/rooms/\(selectedResidence!.id)"
                awvc.airbnbURL = airbnbURL
            }
        }
    }
    
}
