//
//  AccountsAddTableViewController.swift
//  platinumsupport
//
//  Created by Klius on 5/5/16.
//  Copyright © 2016 Klius. All rights reserved.
//

import UIKit

class AccountsAddTableViewController: UITableViewController {
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var nameTextAccount: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    var data:NSData!
    var account:Account?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cancelToAccount"{
            print("cancel")
            
        }
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //you can't save until the info is right and there
        self.navigationItem.rightBarButtonItem!.enabled = false;
        nameTextAccount.addTarget(self, action: "checkFields:", forControlEvents: .EditingDidEnd)
        mailTextField.addTarget(self, action: "checkFields:", forControlEvents: .EditingDidEnd)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/***********
 ***
 *** Checks if all fields are written on
 ***
 **********/
    
    func checkFields(sender: UITextField) {
        sender.text = sender.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
        guard
            let code = nameTextAccount.text where !code.isEmpty,
            let mail = mailTextField.text where !mail.isEmpty
            else { return }
        // enable your button if all conditions are met
        retrieveUserData(nameTextAccount.text!, mail: mailTextField.text!)
    }
    
    func retrieveUserData(code: String, mail: String){
        do{
            let reach:Reachability = try Reachability.reachabilityForInternetConnection()
            if reach.isReachable()
            {
                RestApiManager.sharedInstance.getUserInfo(code, mail: mail) { json in
                    let results = json["profile"]
                    //avisamos al usuario que estamos conectando con guardian
                    self.showChecking()
                    /*
                        print(results.rawString())
                        print(json["error"].rawString())
                        print(results["mail"].stringValue)
                    */
                    if json["error"].exists() {
                        self.showError()
                    }
                    else{
                        self.showOk()
                        self.account = Account(name: results["name"].stringValue, mail: results["mail"].stringValue, code: results["code"].stringValue, selected: false)
                    }
                }
            }
            else
            {
             self.showNoConnection()
            }

        }
        catch is NSError{
            print("boom crash")
        }
        
    }
    
/**********
 ***
 *** Show Warnings to the user via warningLabel
 ***
 ***********/
    func showOk(){
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.warningLabel.text = "La comprobación ha sido un éxito!"
            self.warningLabel.textColor = UIColor.greenColor()
            self.navigationItem.rightBarButtonItem!.enabled = true;
        }
    }
    func showError() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.warningLabel.text = "El código o el mail no són correctos. "
            self.warningLabel.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        }
    }
    func showNoConnection(){
        self.warningLabel.text = "No tienes conexión a internet"
        self.warningLabel.textColor = UIColor.redColor()
    }
    func showChecking(){
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.warningLabel.text = "Comprobando... "
            self.warningLabel.textColor = UIColor.blackColor()
        }
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //shows up the keyboard on touching cell
        switch indexPath.section{
        case 0:
            nameTextAccount.becomeFirstResponder()
            break
        case 0:
            mailTextField.becomeFirstResponder()
            break
        default:
            //Do nothing
            break
        }
        
        
    }
    


}