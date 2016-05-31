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
    
    let baseURL = "http://192.168.1.38:5000/platinum/api/v1.0/"
    
    func getUserInfo(code: String , mail: String,onCompletion: (JSON) -> Void) {
        let route = baseURL + "profile/"+code+"/"+mail
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func updateUserInfo(account: Account,onCompletion:(JSON)->Void){
        let route = baseURL + "profile/"
        
       makeHTTPPutRequest(route, body: account.getBodyRequest(), onCompletion: { json, err in
            onCompletion(json as JSON)
        } )
        
    }
    
    
    //MARK: Perform GET request
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
    
    // MARK: Perform a PUT Request
    private func makeHTTPPutRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to PUT
        request.HTTPMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Set the POST body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            //Debug
            let dataString = NSString(data: jsonBody, encoding: NSUTF8StringEncoding)!
            print(dataString)
            
            request.HTTPBody = jsonBody
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(nil, error)
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(nil, nil)
        }
    }
}
