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
    var servers : NSMutableArray = NSMutableArray()
    var selected: Bool
    
    //ArchivingPaths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("accounts")
    
    
    //TYPES
    
    struct PropertyKey {
        static let idKey = "id"
        static let partnerKey = "partner"
        static let empresaKey = "empresa"
        static let contactoKey = "contacto"
        static let telefonoKey = "telefono"
        static let movilKey = "movil"
        static let mailKey = "mail@mail.me"
        static let serversKey = "servers"
        static let selectedKey = "false"
    }
    
    
    //Initialization
    init(id: String?, partner: String?, empresa: String?, contacto: String?, telefono: String?, movil: String?, mail: String?, servers: [Server],selected: Bool) {
        self.id = id
        self.partner = partner
        self.empresa = empresa
        self.contacto = contacto
        self.telefono = telefono
        self.movil = movil
        self.mail = mail
        self.servers = servers
        self.selected = selected
        
        super.init()
    }
    
    //JSON PUT REQUEST
    func getBodyRequest()->[String: AnyObject]{
        let postItems:[String: AnyObject] = ["Profile":["id": self.id!, "partner": self.partner!, "empresa":self.empresa!, "contacto": self.contacto!, "telefono": self.telefono!, "movil": self.movil! , "mail": self.mail!]]
        //print(postItems)
        return postItems
    }
    
    //NSCODING
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: PropertyKey.idKey)
        aCoder.encodeObject(partner, forKey: PropertyKey.partnerKey)
        aCoder.encodeObject(empresa, forKey: PropertyKey.empresaKey)
        aCoder.encodeObject(contacto, forKey: PropertyKey.contactoKey)
        aCoder.encodeObject(telefono, forKey: PropertyKey.telefonoKey)
        aCoder.encodeObject(movil, forKey: PropertyKey.movilKey)
        aCoder.encodeObject(mail, forKey: PropertyKey.mailKey)
        aCoder.encodeObject(servers, forKey: PropertyKey.serversKey)
        aCoder.encodeBool(selected, forKey: PropertyKey.selectedKey)
    }
    
    required convenience init?(coder aDecoder:NSCoder){
        let id = aDecoder.decodeObjectForKey(PropertyKey.idKey) as! String
        
        let partner = aDecoder.decodeObjectForKey(PropertyKey.partnerKey) as! String
        
        let empresa = aDecoder.decodeObjectForKey(PropertyKey.empresaKey) as! String
        
        let contacto = aDecoder.decodeObjectForKey(PropertyKey.contactoKey) as! String
        
        let telefono = aDecoder.decodeObjectForKey(PropertyKey.telefonoKey) as! String
        
        let movil = aDecoder.decodeObjectForKey(PropertyKey.movilKey) as! String
        
        let mail = aDecoder.decodeObjectForKey(PropertyKey.mailKey) as! String
        
        let servers = aDecoder.decodeObjectForKey(PropertyKey.serversKey) as! [Server]
        
        let selected = aDecoder.decodeBoolForKey(PropertyKey.selectedKey)
        
        
        //must call init
        self.init(id: id, partner: partner, empresa: empresa, contacto: contacto, telefono: telefono, movil: movil, mail: mail, servers: servers,selected: selected)
    }
    

}