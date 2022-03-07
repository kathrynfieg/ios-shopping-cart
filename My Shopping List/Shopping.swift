//
//  Shopping.swift
//  My Shopping List
//
//  Created by Kathryn Fieg on 5/11/19.
//  Copyright © 2019 Kathryn Fieg. All rights reserved.
//

import Foundation
public class Shopping{
    
    public var item: String
    public var price: Double
    public var group: String
    public var qty: Int
    public var notes: String
    
    //default
    public init(){
        self.item = ""
        self.price = 0
        self.group = ""
        self.qty = 0
        self.notes = ""
    }
    
    public init(item:String, price:Double, group:String, qty:Int, notes:String){
        self.item = item
        self.price = price
        self.group = group
        self.qty = qty
        self.notes = notes
    }
    
    public func toString() -> String{
        return " Price: " + String(format: "$%.2f", self.price) + " Quantity: " + String(format: "%d", self.qty) + " Category: " + self.group
    }
    
}
