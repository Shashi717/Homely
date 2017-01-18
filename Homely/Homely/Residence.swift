//
//  Residence.swift
//  testHomely
//
//  Created by Madushani Lekam Wasam Liyanage on 1/9/17.
//  Copyright © 2017 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import Foundation

enum ResidenceModelParseError: Error {
    case results(json: Any)
    //case image(image: Any)
}

class Residence {
    
    let name: String
    let city: String
    let latitude: Double
    let longitude: Double
    let bedrooms: Int
    let beds: Int
    let personCapacity: Int
    let address: String
    let thumbnail: String
    let mainImage: String
    let images: [String]
    let currency: String
    let pricePerNight: Int
    let hostName: String
    let hostImage: String
    let rating: String
    let id: Int
    let bathrooms: Int
    
    init(name: String, city: String, latitude: Double, longitude: Double, bedrooms: Int, beds: Int, personCapacity: Int, address: String, thumbnail: String, mainImage: String, images: [String], currency: String, pricePerNight: Int, hostName: String, hostImage: String, rating: String, id: Int, bathrooms: Int) {
        
        self.name = name
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        self.bedrooms = bedrooms
        self.beds = beds
        self.personCapacity = personCapacity
        self.address = address
        self.thumbnail = thumbnail
        self.mainImage = mainImage
        self.images = images
        self.currency = currency
        self.pricePerNight = pricePerNight
        self.hostName = hostName
        self.hostImage = hostImage
        self.rating = rating
        self.id = id
        self.bathrooms = bathrooms
    }
    
    static func getResidence(from data: Data) -> [Residence]? {
        var residencesToReturn: [Residence] = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String:AnyObject] = jsonData as? [String:AnyObject], let searchResults:[[String:AnyObject]] = response["search_results"] as? [[String:AnyObject]] else {
                throw ResidenceModelParseError.results(json: jsonData)
                
            }
            
            //            "listing_currency": "USD",
            //            "localized_currency": "USD",
            //            "localized_nightly_price": 69,
            //            "localized_service_fee": 0,
            //            "localized_total_price": 0,
            //            "long_term_discount_amount_as_guest": 0,
            //            "nightly_price": 69,
            for result in searchResults {
                var hostImage = " "
                var rating = "N/A"
                let dict = result["listing"] as? [String:AnyObject]
                let starRating = nullToNil(value: dict?["star_rating"])
                
                if let listing = result["listing"] as? [String:Any],
                    let pricing = result["pricing_quote"] as? [String:Any],
                    let name = listing["name"] as? String,
                    let city = listing["city"] as? String,
                    let latitude = listing["lat"] as? Double,
                    let longitude = listing["lng"] as? Double,
                    let bedrooms = listing["bedrooms"] as? Int,
                    let beds = listing["beds"] as? Int,
                    let personCapacity = listing["person_capacity"] as? Int,
                    let address = listing["public_address"] as? String,
                    let thumbnail = listing["thumbnail_url"] as? String,
                    let mainImage = listing["picture_url"] as? String,
                    let images = listing["picture_urls"] as? [String], //or xl_picture_urls
                    let currency = pricing["listing_currency"] as? String,
                    let pricePerNight = pricing["nightly_price"] as? Int,
                    let hostDetails = listing["primary_host"] as? [String:Any],
                    let hostName = hostDetails["first_name"] as? String,
                    let hostHasImage = hostDetails["has_profile_pic"] as? Bool,
                    let id = listing["id"] as? Int,
                    let bathrooms = listing["bathrooms"] as? Int
                    
                {
                    
                    if let rate = starRating {
                        rating = String(describing: rate)
                    }
                    
                    if hostHasImage == true {
                        hostImage = hostDetails["picture_url"] as! String
                    }
                    
                    let residence = (Residence.init(name: name, city: city, latitude: latitude, longitude: longitude, bedrooms: bedrooms, beds: beds, personCapacity: personCapacity, address: address, thumbnail: thumbnail, mainImage: mainImage, images: images, currency: currency, pricePerNight: pricePerNight, hostName: hostName, hostImage: hostImage, rating: rating, id: id, bathrooms: bathrooms))
                    residencesToReturn.append(residence)
                }
            }
        }
        catch let ResidenceModelParseError.results(json: json)  {
            print("Error encountered with parsing elements for object: \(json)")
        }
            //        catch let ResidenceParseError.image(image: im)  {
            //            print("Error encountered with parsing 'image': \(im)")
            //        }
        catch {
            print("Unknown parsing error")
        }
        
        return residencesToReturn
    }
    
    
}

//http://stackoverflow.com/questions/37606376/how-to-handle-json-null-values-in-swift
func nullToNil(value: AnyObject?) -> AnyObject? {
    if value is NSNull {
        return nil
    } else {
        return value
    }
}
