//
//  Place.swift
//  Homely
//
//  Created by Jermaine Kelly on 1/9/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import Foundation

class Place{
    let name: String
    let latitude: Double?
    let longitude: Double?
    let icon: String
    let isOpen: Bool?
    let photos: String
    let types: [String]
    
    init?(placeInfoDictionary: [String:AnyObject]){
        
        guard let location = placeInfoDictionary["geometry"]?["location"] as? [String: Double] else {
            return nil }
        
        self.name = placeInfoDictionary["name"] as? String ?? ""
        self.icon = placeInfoDictionary["icon"] as? String ?? ""
        self.photos = ""
        self.isOpen = placeInfoDictionary["opening_hours"]?["open_now"] as? Bool
        self.latitude = location["lat"] ?? nil
        self.longitude = location["lng"] ?? nil
        self.types = placeInfoDictionary["types"] as? [String] ?? []

    }
    
    static func makePlaceObj(from data:Data)->[Place]{
        var placeResults: [Place] = []
        
        do{
            let results = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            
            if let resultsArr: [[String:AnyObject]] = results["results"] as? [[String:AnyObject]]{
                
                for resultDic in resultsArr{
                    if let place = Place(placeInfoDictionary: resultDic){
                        placeResults.append(place)
                    }
                }
            }
            
        }catch{
            print(error.localizedDescription)
        }
        
        return placeResults
    }
}
