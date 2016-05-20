//
//  Account.swift
//  platinumsupport
//
//  Created by Klius on 5/5/16.
//  Copyright © 2016 Klius. All rights reserved.
//

import Foundation
import UIKit

struct Account {
    var name: String?
    var mail: String?
    var code: String?
    var selected: Bool
    
    init(name: String?, mail: String?, code: String?, selected: Bool) {
        self.name = name
        self.mail = mail
        self.code = code
        self.selected = selected
    }
}