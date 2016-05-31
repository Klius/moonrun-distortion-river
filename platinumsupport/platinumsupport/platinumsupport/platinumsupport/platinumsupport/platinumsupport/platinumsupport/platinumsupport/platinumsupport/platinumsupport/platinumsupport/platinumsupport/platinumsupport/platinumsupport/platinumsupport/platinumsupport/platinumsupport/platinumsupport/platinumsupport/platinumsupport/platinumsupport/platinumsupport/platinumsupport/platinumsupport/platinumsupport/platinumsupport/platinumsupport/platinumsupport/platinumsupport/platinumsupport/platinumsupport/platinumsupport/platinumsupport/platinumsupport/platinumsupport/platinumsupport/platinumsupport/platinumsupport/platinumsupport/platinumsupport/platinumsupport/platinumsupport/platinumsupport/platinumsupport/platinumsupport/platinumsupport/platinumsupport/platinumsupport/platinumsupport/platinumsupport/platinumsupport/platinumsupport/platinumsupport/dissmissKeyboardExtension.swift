//
//  dissmissKeyboardExtension.swift
//  platinumsupport
//
//  Created by Klius on 26/5/16.
//  Copyright © 2016 Klius. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
public func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
}


public func dismissKeyboard() {
    view.endEditing(true)
}
}