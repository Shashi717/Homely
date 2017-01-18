//
//  SearchResultsViewController.swift
//  Homely
//
//  Created by Madushani Lekam Wasam Liyanage on 1/10/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit
import CoreLocation
import expanding_collection

class SearchResultsViewController: ExpandingViewController, CLLocationManagerDelegate,UITextFieldDelegate,FilterButtonPressedDelegate{
    
    fileprivate var cellsIsOpen = [Bool]()
    let geoCoder: CLGeocoder = CLGeocoder()
    let userDefault = UserDefaults.standard
    var residences: [Residence] = []
    var selectedResidence: Residence?
    var selectedImage: UIImage?
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = 100.0
        locMan.distanceFilter = 50.0
        return locMan
    }()
    var currentLocation: String?{
        didSet{
            locationManager.stopUpdatingLocation()
            searchTextField.placeholder = "Results near \(currentLocation!)"
            let currentLocationWithSaftey = currentLocation?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let endpoint: String = "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&_limit=10&location=\(currentLocationWithSaftey!)"
            getSeachResults(from: endpoint)
        }
    }
    let searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Search by city"
        textField.font = UIFont.systemFont(ofSize: 20, weight: 5)
        textField.layer.cornerRadius = 5
        textField.layer.shadowRadius = 10.0
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 10)
        textField.layer.masksToBounds = false
        textField.layer.shadowOpacity = 0.5
        return textField
    }()
    let filterButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.shadowRadius = 10.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowOpacity = 0.5
        button.setTitle("Filter", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
}

// MARK: life cicle

extension SearchResultsViewController {
    
    override func viewDidLoad() {
        //        itemSize = CGSize(width: 325, height: 375)
        
        super.viewDidLoad()
        
        locationManager.delegate = self
        searchTextField.delegate = self
        
        let nib = UINib(nibName: "SearchResultCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "SearchResultCellIdentifier")
        registerCell()
        
        addGestureToView(collectionView!)
        configureNavBar()
        
        setUpViews()
        
    }
}

// MARK: Helpers

extension SearchResultsViewController {
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: SearchResultCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: SearchResultCollectionViewCell.self))
    }
    
    fileprivate func fillCellIsOpeenArry() {
        for _ in residences {
            cellsIsOpen.append(false)
        }
    }
    
    fileprivate func getViewController(for residence:Residence) -> ExpandingTableViewController {
        let storyboard = UIStoryboard(storyboard: .Main)
        let toViewController: ResidenceDetailTableViewController = storyboard.instantiateViewController()
        toViewController.selectedResidence = residence
        toViewController.selectedImage = selectedImage
        return toViewController
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}

/// MARK: Gesture

extension SearchResultsViewController {
    
    fileprivate func addGestureToView(_ toView: UIView) {
        let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(SearchResultsViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(SearchResultsViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        toView.addGestureRecognizer(gesutereUp)
        toView.addGestureRecognizer(gesutereDown)
    }
    
    //
    func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? SearchResultCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            // navigationController?.pushViewController(getViewController(), animated: false)
            
            navigationController?.isNavigationBarHidden = false
            pushToViewController(getViewController(for: residences[indexPath.row]))
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
        else if sender.direction == .up {
            self.hideSearchBar()
        }
        else if sender.direction == .down {
            self.showSearchBar()
        }
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
    }
}

// MARK: UIScrollViewDelegate

extension SearchResultsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // pageLabel.text = "\(currentIndex+1)/\(items.count)"
    }
}

// MARK: UICollectionViewDataSource

extension SearchResultsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? SearchResultCollectionViewCell else { return }
        //cell.imageView.image = nil
        
        let index = (indexPath as NSIndexPath).row % residences.count
        let residence = residences[index]
        
        let imageString = residence.mainImage
        
        let hostImageString = residence.hostImage
        if hostImageString != " " {
            APIRequestManager.manager.getData(endPoint: hostImageString) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        cell.hostImageView.image = validImage
                    }
                }
            }
        }
        
        APIRequestManager.manager.getData(endPoint: imageString) { (data: Data?) in
            if  let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.imageView.image = validImage
                    self.selectedImage = validImage
                }
            }
        }
        
        cell.titleLabel.text = residence.name
        cell.priceLabel.text = "\(residence.currency) \(String(residence.pricePerNight)) / Night "
        cell.hostNameLabel.text = "Host: \(residence.hostName)"
        cell.ratingLabel.text = "Rating: \(residence.rating)"
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }
    
    //        func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
    //            guard let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCollectionViewCell
    //                , currentIndex == (indexPath as NSIndexPath).row else { return }
    //
    //            selectedResidence = residences[indexPath.row]
    //            if cell.isOpened == false {
    //                cell.cellIsOpen(true)
    //            } else {
    //
    //                pushToViewController(getViewController())
    //
    //                if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
    //                    rightButton.animationSelected(true)
    //                }
    //            }
    //        }
}

// MARK: UICollectionViewDataSource
extension SearchResultsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return residences.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCellIdentifier", for: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewSegueIdentifier" {
            if let rdtvc = segue.destination as? ResidenceDetailTableViewController {
                rdtvc.selectedResidence = selectedResidence
                rdtvc.selectedImage = selectedImage
            }
        }
    }
}


//MARK: - CLLocationManager Delegate
extension SearchResultsViewController{
    
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
    
}

extension SearchResultsViewController{

    //MARK:- TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let searchQuery = searchTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines){
            
            if searchQuery == "" {
                
                showEmptySearchAlert()
                
            }else{
                
                let percentEncodedLocation = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let endpoint: String = "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&_limit=10&location=\(percentEncodedLocation!)"
                getSeachResults(from: endpoint)
                
                textField.resignFirstResponder()
                
                addToHistory(query: searchQuery)
            }
        }
        return true
    }
    
    //MARK: Filter Results Delegate
    func getFilteredResults(from filterEndpoint: String) {
        
        if let searchQuery = searchTextField.text{
            let percentEncodedLocation = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            getSeachResults(from: filterEndpoint + "&location=\(percentEncodedLocation!)")
        }
    }
}

//MARK:- Utilities
extension SearchResultsViewController{
    
    func getSeachResults(from endpoint: String){
        
        APIRequestManager.manager.getData(endPoint: endpoint) { (data: Data?) in
            
            guard let validData = data,
                let newValidResidences = Residence.getResidence(from: validData) else { return }
            
            DispatchQueue.main.async {
                self.residences = newValidResidences
                self.fillCellIsOpeenArry()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func setUpViews(){
        addFilterAndSearchBar()
    }
    
    func addFilterAndSearchBar(){
        
        self.view.addSubview(searchTextField)
        self.view.addSubview(filterButton)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Search textfield Constraints
        searchTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        searchTextField.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: -20).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let showHistoryButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        showHistoryButton.setBackgroundImage(#imageLiteral(resourceName: "historyImage"), for: .normal)
        showHistoryButton.addTarget(self, action: #selector(showHistory), for: .touchUpInside)
        //Adds padding to textfield
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchTextField.frame.height))
        
        searchTextField.leftView = paddingView
        searchTextField.rightView = showHistoryButton
        searchTextField.leftViewMode = .always
        searchTextField.rightViewMode = .always
        
        //Filter button constraints
        filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        filterButton.addTarget(self, action: #selector(showfilter), for: .touchUpInside)
    }
    
    func showfilter(){
        let storyboard = UIStoryboard(storyboard: .Main)
        let filterViewController = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        filterViewController.dismissButtonDelegate = self
        //filterViewController.modalTransitionStyle = .flipHorizontal
        present(filterViewController, animated: true, completion: nil)
    }
    
    func showSearchBar(){
        UIView.animate(withDuration: 0.5) {
            self.searchTextField.alpha = 1
            self.filterButton.alpha = 1
        }
    }
    
    func hideSearchBar(){
        UIView.animate(withDuration: 0.5) {
            self.searchTextField.alpha = 0
            self.filterButton.alpha = 0
        }
    }
    
    func showHistory(){
        let historyVC: HistoryViewController = HistoryViewController()
        historyVC.modalTransitionStyle = .coverVertical
        present(historyVC, animated: true, completion: nil)
    }
    
    func showEmptySearchAlert(){
        let alert: UIAlertController = UIAlertController(title: "Homely", message: "Nothing to search for. Please check your search query", preferredStyle: .alert)
        let okActon: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okActon)
        present(alert, animated: true, completion: nil)
    }
}

//MARK:- User Defaults
extension SearchResultsViewController{
    
    func addToHistory(query: String){
        var historyDic = [String: Date]()
        
        // userDefault.removeObject(forKey: "History")
        if let dic = userDefault.object(forKey: "History") as? [String:Date]{
            historyDic = dic
        }
        
        historyDic[query] = Date()
        userDefault.set(historyDic, forKey: "History")
    }
}
