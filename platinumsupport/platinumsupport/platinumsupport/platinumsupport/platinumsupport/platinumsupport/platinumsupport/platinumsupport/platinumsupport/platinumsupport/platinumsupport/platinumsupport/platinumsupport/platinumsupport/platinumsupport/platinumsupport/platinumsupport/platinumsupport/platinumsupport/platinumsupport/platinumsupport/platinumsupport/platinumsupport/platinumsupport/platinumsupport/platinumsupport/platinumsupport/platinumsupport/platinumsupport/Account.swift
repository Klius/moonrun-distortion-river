//
//  Account.swift
//  platinumsupport
//
//  Created by Klius on 5/5/16.
//  Copyright © 2016 Klius. All rights reserved.
//

import Foundation
import UIKit


class Account: NSObject,NSCoding {
    //Properties
    
    var id: String?
    var partner: String?
    var empresa: String?
    var contacto: String?
    var telefono: String?
    var movil: String?
    var mail: String?
    
    var selected: Bool
    
    //ArchivingPaths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("accounts")
    
    
    //TYPES
    
    struct PropertyKey {
        static let nameKey = "name"
        static let mailKey = "mail@mail.me"
        static let codeKey = "qwerty"
        static let selectedKey = "false"
    }
    
    
    //Initialization
    init(name: String?, mail: String?, code: String?, selected: Bool) {
        self.name = name
        self.mail = mail
        self.code = code
        self.selected = selected
        
        super.init()
    }
    
    //JSON PUT REQUEST
    func getBodyRequest()->[String: AnyObject]{
      let postItems:[String: AnyObject] = ["Profile":["code": self.code!, "mail": self.mail!, "name": self.name!]]
        print(postItems)
        return postItems
    }
    
    //NSCODING
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(mail, forKey: PropertyKey.mailKey)
        aCoder.encodeObject(code, forKey: PropertyKey.codeKey)
        aCoder.encodeBool(selected, forKey: PropertyKey.selectedKey)
    }
    
    required convenience init?(coder aDecoder:NSCoder){
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        let mail = aDecoder.decodeObjectForKey(PropertyKey.mailKey) as! String
        
        let code = aDecoder.decodeObjectForKey(PropertyKey.codeKey) as! String
        
        let selected = aDecoder.decodeBoolForKey(PropertyKey.selectedKey)
        
        
        //must call init
        self.init(name: name, mail: mail, code: code, selected: selected)
    }
    

}