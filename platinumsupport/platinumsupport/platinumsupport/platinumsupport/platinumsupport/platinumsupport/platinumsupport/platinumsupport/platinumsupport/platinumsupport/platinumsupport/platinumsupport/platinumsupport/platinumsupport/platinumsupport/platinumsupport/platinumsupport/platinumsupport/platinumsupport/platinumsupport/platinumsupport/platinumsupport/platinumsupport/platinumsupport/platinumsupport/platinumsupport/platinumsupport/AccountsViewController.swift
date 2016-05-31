//
//  AccountsViewController.swift
//  platinumsupport
//
//  Created by Klius on 5/5/16.
//  Copyright © 2016 Klius. All rights reserved.
//

import UIKit

class AccountsViewController: UITableViewController {
    var accounts:[Account] = []
    var selectedAccountIndex:Int?
    
    
    //cancel Function
    @IBAction func cancelToAccountsViewController(segue:UIStoryboardSegue) {
    }
    //Save account function
    @IBAction func saveAccountDetail(segue:UIStoryboardSegue) {
        if let AccountsAddTableViewController = segue.sourceViewController as? AccountsAddTableViewController{
            //add the new account to the account array
            
            print("row to update :",tableView.indexPathForSelectedRow)
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                let account = AccountsAddTableViewController.account
                accounts[selectedIndexPath.row] = account!
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                updateProfileOnServer(account!)
            }
            else  {
                if let account = AccountsAddTableViewController.account{
                    accounts.append(account)
                    //update the tableView
                    let indexPath = NSIndexPath(forRow: accounts.count-1, inSection: 0)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    //Save accounts
                    saveAccounts()
                }
            }
        }
    }
    
    
    //selects the Account
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tapRecognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.view.addGestureRecognizer(longPressRecognizer)
        // Load any saved Accounts, otherwise load sample data.
        if let savedAccounts = loadAccounts() {
            accounts += savedAccounts
            selectedAccountIndex = getSelectedIndex()
        } else {
            // Do Nothing
        }

    }
    
    func updateProfileOnServer(account:Account){
        do{
            let reach:Reachability = try Reachability.reachabilityForInternetConnection()
            if reach.isReachable()
            {
                RestApiManager.sharedInstance.updateUserInfo(account) { json in
                    let results = json["profile"]
                    /*
                     print(results.rawString())
                     print(json["error"].rawString())
                     print(results["mail"].stringValue)
                     */
                    if json["error"].exists() {
                        self.updateProfileOnServer(account)
                    }
                    else{
                        self.saveAccounts()
                    }
                }
            }
            else
            {
                //No hay conexión
            }
            
        }
        catch is NSError{
            print("Error reaching while updating")
        }
    }
    
    func getSelectedIndex() -> Int{
        var selectedAccountIndex:Int = 0
        var index:Int = 0
            for account in accounts{
                if account.selected {
                    selectedAccountIndex = index
                }
                index += 1
            }
        return selectedAccountIndex
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accounts.count
    }

    /**
    *** Configuración de la celda dentro del tableview (texto a mostrar i demás) i'm sexy and i know it - The punk
    *****
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! AccountCell
        
        let account = accounts[indexPath.row] as Account
        cell.account = account
        
        
        return cell

    }
    
    
    //Called, when long press occurred
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = longPressGestureRecognizer.locationInView(self.view)
            if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
                
                
                //Other row is selected - need to deselect it
                
                if let index = selectedAccountIndex{
                    if index < accounts.count {
                        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! AccountCell
                        cell.selectedImageView.image = UIImage(named: "deselected")
                        accounts[index].selected = false
                    }
                }
                
                //Select the new row
                selectedAccountIndex = indexPath.row
                accounts[selectedAccountIndex!].selected = true
                //update the checkmark for the current row
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! AccountCell
                cell.selectedImageView.image = UIImage(named: "selected")
                
                //Save changes
                saveAccounts()
                
                //Debug only!
                //printSelectedAccount()
            }
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            accounts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveAccounts()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
/********
 *
 * Segues
 *
 **************/
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editProfileSegue" {
            let profileDetailViewController = segue.destinationViewController as! AccountsAddTableViewController
            
            // Get the cell that generated this segue.
            if let selectedProfileCell = sender as? AccountCell {
                let indexPath = tableView.indexPathForCell(selectedProfileCell)!
                let selectedProfile = accounts[indexPath.row]
                //pass the profile info!
                profileDetailViewController.account = selectedProfile
            }
        }
        else{
            print("Adding new profile.")
        }
    }
    

    
    

   /***************
    ****
    **** Platinum support : Persistence
    ****
    *****************/
    
    func saveAccounts(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(accounts, toFile: Account.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save account")
        }
    }
    
    
    
    func loadAccounts() -> [Account]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Account.ArchiveURL.path!) as? [Account]
    }
    

    
    /*********
    ***
    *** Debug
    ***
    *********/

    
    func printSelectedAccount(){
        for i in 0...accounts.count-1{
            if accounts[i].selected{
                print(accounts[i].name)
            }
        }
    }
    
    


}
