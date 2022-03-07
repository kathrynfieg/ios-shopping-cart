//
//  FirstViewController.swift
//  My Shopping List
//
//  Created by Kathryn Fieg on 2/11/19.
//  Copyright © 2019 Kathryn Fieg. All rights reserved.
//

import UIKit
import SQLite3

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db: OpaquePointer? = nil
    
    
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var movieTableView: UITableView!
    
    func selectQuery() {
        let selectQueryStatement = "SELECT * FROM shoppinglist"
        var queryStatement: OpaquePointer? = nil
        if (sqlite3_prepare_v2(db, selectQueryStatement, -1, &queryStatement, nil) == SQLITE_OK)
        {
            print("Query Result:")
            while (sqlite3_step(queryStatement) == SQLITE_ROW)
            {
                let key = sqlite3_column_int(queryStatement, 0)
                let itemField = sqlite3_column_text(queryStatement, 1)
                let itemName = String(cString: itemField!)
                let priceField = sqlite3_column_text(queryStatement, 2)
                let itemPrice = String(cString: priceField!)
                let groupField = sqlite3_column_text(queryStatement, 3)
                let itemGroup = String(cString: groupField!)
                let itemQty = Int(sqlite3_column_int(queryStatement, 4))
                let notesField = sqlite3_column_text(queryStatement, 5)
                let itemNotes = String(cString: notesField!)
                
                let itemPriceDouble = Double(itemPrice)!

                print("\(key) | \(itemName)")
                let s = Shopping(item: itemName, price: itemPriceDouble, group: itemGroup, qty: itemQty, notes: itemNotes)
                appDelegate.shoppingArray.append(s)
            }
        }
        else
        {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        sqlite3_close(db)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.shoppingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        let shopping:Shopping = appDelegate.shoppingArray[indexPath.row]
        cell.textLabel!.text = shopping.item
        //cell.imageView!.image = UIImage(named:"movie.ico")
        cell.detailTextLabel!.text = shopping.toString()
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Colour.sharedInstance.selectedColour = UIColor(red:0.99, green:0.84, blue:0.24, alpha:1.0)
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK {
            print("Successfully opened connection to database ")
            //Run the select query
            selectQuery()
            
            
        } else {
            print("Unable to open database")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieTableView.reloadData()
    }
    
    func deleteQuery(itemName:String){
        let deleteSQL = "DELETE FROM shoppinglist WHERE item = ('\(itemName)')"
        print(deleteSQL)
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK
        {
            print("Successfully opened connection to database ")
            
            if (sqlite3_prepare_v2(db, deleteSQL, -1, &queryStatement, nil) == SQLITE_OK)
            {
                if sqlite3_step(queryStatement) == SQLITE_DONE
                {
                    print("Record Deleted!")
                    //Display using an AlertView
                    let alertController = UIAlertController (title:"Success", message:"Shopping Item Deleted", preferredStyle:.alert)
                    let alertAction = UIAlertAction(title:"Ok", style:.default, handler:nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion:nil)
                }
                else
                {
                    print("Fail to Delete")
                }
                sqlite3_finalize(queryStatement)
            }
            else
            {
                print("Delete statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else
        {
            print("Unable to open database")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            //Delete from the database
            var selectedItem:Shopping = appDelegate.shoppingArray[indexPath.row]
            var itemName:String = selectedItem.item
            deleteQuery(itemName: itemName)
            //remove array from the table
            appDelegate.shoppingArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if (editingStyle == .insert){
            //idk yet
        }
    }
    
    //Colour.sharedInstance.selectedColour = UIColor(red:0.99, green:0.84, blue:0.24, alpha:1.0)
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listLabel.textColor = Colour.sharedInstance.selectedColour
    }


}

