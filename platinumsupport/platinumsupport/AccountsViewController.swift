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
            if let account = AccountsAddTableViewController.account {
                accounts.append(account)
                //update the tableView
                let indexPath = NSIndexPath(forRow: accounts.count-1, inSection: 0)
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                //Save accounts
                saveAccounts()
            }
        }
    }
    
    
    //selects the Account
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedAccountIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! AccountCell
            cell.selectedImageView.image = UIImage(named: "deselected")
            accounts[index].selected = false
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load any saved Accounts, otherwise load sample data.
        if let savedAccounts = loadAccounts() {
            accounts += savedAccounts
            for index in 0...accounts.count-1 {
                if accounts[index].selected{
                    selectedAccountIndex = index
                }
            }
        } else {
            // Load the sample data.
            
        }

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
    *** Configuración de la celda dentro del tableview (texto a mostrar i demás)
    *****
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! AccountCell
        
        let account = accounts[indexPath.row] as Account
        cell.account = account
        
        
        return cell

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
                profileDetailViewController.account = selectedProfile            }
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
