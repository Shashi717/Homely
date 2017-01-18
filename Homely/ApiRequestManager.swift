//
//  ApiRequestManager.swift
//  Homely
//
//  Created by Jermaine Kelly on 1/9/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import Foundation
let googleAPIKey: String = "AIzaSyCBb_tIlTkF4FaLXdCe9qISjOpYZl-fCCs"
class APIRequestManager {
    
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            
            callback(validData)
            }.resume()
    }
}
