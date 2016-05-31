//
//  Server.swift
//  platinumsupport
//
//  Created by Klius on 31/5/16.
//  Copyright © 2016 Klius. All rights reserved.
//

import Foundation
import UIKit


class Server:NSObject,NSCoding{
    var ip: String?
    var ref: String?
    
    //Initialization
    init(ip: String?, ref: String?) {
        self.ip = ip
        self.ref = ref
        
        super.init()
    }
    
    
    //TYPES
    
    struct PropertyKey {
        static let ipKey = "id"
        static let refKey = "reference"
    }
    
    //NSCODING
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(ip, forKey: PropertyKey.ipKey)
        aCoder.encodeObject(ref, forKey: PropertyKey.refKey)
    }
    
    required convenience init?(coder aDecoder:NSCoder){
        let ip = aDecoder.decodeObjectForKey(PropertyKey.ipKey) as! String
        
        let ref = aDecoder.decodeObjectForKey(PropertyKey.refKey) as! String
        
        //must call init
        self.init(ip: ip, ref: ref)
    }

}
