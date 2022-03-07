//
//  SecondViewController.swift
//  My Shopping List
//
//  Created by Kathryn Fieg on 2/11/19.
//  Copyright © 2019 Kathryn Fieg. All rights reserved.
//

import UIKit
import SQLite3

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var groupArray:[String] = ["Beverages", "Bread/Bakery", "Canned/Jarred Goods", "Dairy", "Dry/Baking Goods", "Frozen Foods", "Meat", "Produce", "Cleaners", "Paper Goods", "Personal Care", "Other"]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db: OpaquePointer? = nil
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var groupPickerView: UIPickerView!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    //warning label
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupArray[row]
    }
    
    func insertQuery(item:String, price:Double, group:String, qty:Int, notes:String){
        
        var insertPrice:String;
        insertPrice = String(price)
        
        
        let insertSQL = "INSERT INTO shoppinglist(item, price, 'group', qty, notes) VALUES ('\(item)', '\(insertPrice)', '\(group)', \(qty), '\(notes)')"
        print(insertSQL)
        
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK
        {
            print("Successfully opened connection to database ")
            
            if (sqlite3_prepare_v2(db, insertSQL, -1, &queryStatement, nil) == SQLITE_OK)
            {
                if sqlite3_step(queryStatement) == SQLITE_DONE
                {
                    print("Record Inserted!")
                    //Display using an AlertView
                    let alertController = UIAlertController (title:"Success", message:"Shopping Item Added", preferredStyle:.alert)
                    let alertAction = UIAlertAction(title:"Ok", style:.default, handler:nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion:nil)
                }
                else
                {
                    print("Fail to Insert")
                }
                sqlite3_finalize(queryStatement)
            }
            else
            {
                print("Insert statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else
        {
            print("Unable to open database")
        }
        
    }
    
    @IBAction func addClicked(_ sender: UIButton) {
        var itemName:String?
        var itemPrice:Double?
        var itemGroup:String?
        var itemQty:Int?
        var itemNotes:String?
        
        //validation
        var warningMessage:String? = ""
        
        if itemNameTextField.text!.isEmpty{
            warningMessage = "Item Name is Required"
            warningLabel.text = warningMessage
            warningLabel.isHidden = false;
            return
        }
        if priceTextField.text!.isEmpty{
            warningMessage = "Price is Required"
            warningLabel.text = warningMessage
            warningLabel.isHidden = false;
            return
        }
        if qtyTextField.text!.isEmpty{
            warningMessage = "Quantity is Required"
            warningLabel.text = warningMessage
            warningLabel.isHidden = false;
            return
        }
        if Int(qtyTextField.text!)! < 1{
            warningMessage = "Quantity must be greater than 0"
            warningLabel.text = warningMessage
            warningLabel.isHidden = false;
            return
        }
        
        itemName = itemNameTextField.text
        itemPrice = NSString(string:priceTextField.text!).doubleValue
        itemGroup = groupArray[groupPickerView.selectedRow(inComponent: 0)]
        itemQty = NSString(string:qtyTextField.text!).integerValue
        itemNotes = notesTextField.text
        
        print(itemGroup!)
        
        insertQuery(item: itemName!, price: itemPrice!, group: itemGroup!, qty: itemQty!, notes: itemNotes!)
        let s = Shopping(item: itemName!, price: itemPrice!, group: itemGroup!, qty: itemQty!, notes: itemNotes!)
        appDelegate.shoppingArray.append(s)
        
        print("Record Added")
        
        itemNameTextField.text = ""
        priceTextField.text = ""
        qtyTextField.text = ""
        notesTextField.text = ""
        warningLabel.text = ""
        warningLabel.isHidden = true;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Colour.sharedInstance.selectedColour = UIColor(red:0.99, green:0.84, blue:0.24, alpha:1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLabel.textColor = Colour.sharedInstance.selectedColour
        addBtn.backgroundColor = Colour.sharedInstance.selectedColour
    }


}

