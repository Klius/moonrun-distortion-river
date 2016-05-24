//
//  RestApiManager.swift
//  platinumsupport
//
//  Created by Klius on 18/5/16.
//  Copyright © 2016 Klius. All rights reserved.
//

import Foundation
typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    let baseURL = "http://192.168.1.40:5000/platinum/api/v1.0/"
    
    func getUserInfo(code: String , mail: String,onCompletion: (JSON) -> Void) {
        var route = baseURL + "profile/"+code+"/"+mail
        route = route.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let encodedString = path.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLFragmentAllowedCharacterSet())
        let request = NSMutableURLRequest(URL: NSURL(string: encodedString!)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        task.resume()
    }
}
