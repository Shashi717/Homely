//
//  FilterViewController.swift
//  Homely
//
//  Created by Kareem James on 1/10/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit

//Protocol 
protocol FilterButtonPressedDelegate{
    func getFilteredResults(from filterEndPoint:String)
}

class FilterViewController: UIViewController {
    
    var dismissButtonDelegate :FilterButtonPressedDelegate?
    var beds: Int = 2
    var bedrooms: Int = 2
    var price: Int = 50
    var guest: Int = 1
    var valueChange: Bool = false{
        didSet{
            dismissButton.setTitle("Apply Filter", for: .normal)
        }
    }
    
    // Labels
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pricePerNightLabel: UILabel!
    @IBOutlet weak var guestsLabel: UILabel!
    @IBOutlet weak var noOfGuestsLabel: UILabel!
    @IBOutlet weak var bedsLabel: UILabel!
    @IBOutlet weak var noOfBedsLabel: UILabel!
    @IBOutlet weak var bedroomsLabel: UILabel!
    @IBOutlet weak var noOfBedroomsLabel: UILabel!
    
    // Slider
    @IBOutlet weak var priceSlider: UISlider!
    @IBAction func priceSliderAction(_ sender: UISlider) {
        price = Int(sender.value)
        valueChange = true
        priceLabel.text = "$\(Int(priceSlider.value))"
    }
    
    // Steppers
    @IBOutlet weak var guestsStepper: UIStepper!
    @IBAction func guestsStepperAction(_ sender: Any) {
        guest = Int(guestsStepper.value)
        valueChange = true
        guestsLabel.text = String(Int(guestsStepper.value))
    }
    
    @IBOutlet weak var bedsStepper: UIStepper!
    @IBAction func bedsStepperAction(_ sender: Any) {
        beds = Int(bedsStepper.value)
        valueChange = true
        bedsLabel.text = String(Int(bedsStepper.value))
    }
    
    @IBOutlet weak var bedroomsStepper: UIStepper!
    @IBAction func bedroomsStepperAction(_ sender: Any) {
        bedrooms = Int(bedroomsStepper.value)
        valueChange = true
        bedroomsLabel.text = String(Int(bedroomsStepper.value))
    }
    
    // Buttons
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBAction func dimissButtonAction(_ sender: Any) {
        if valueChange{
            let filterEndpoint = makeEndpointFromValues()
            self.dismissButtonDelegate?.getFilteredResults(from: filterEndpoint)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        applyButtonProperties()

    }
    
    func applyButtonProperties() {
        dismissButton.setTitleColor(.black, for: .normal)
        dismissButton.layer.cornerRadius = 5
        dismissButton.backgroundColor = .white
        dismissButton.layer.borderColor = UIColor.black.cgColor
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.shadowRadius = 10.0
        dismissButton.layer.shadowColor = UIColor.black.cgColor
        dismissButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        dismissButton.layer.masksToBounds = false
        dismissButton.layer.shadowOpacity = 0.5
    }
    
    func makeEndpointFromValues()->String{
        let endpoint = "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&price_max\(price)&guest=\(guest)&max_beds=\(beds)&min_bedrooms=\(bedrooms)"
        return endpoint
    }
    
}

