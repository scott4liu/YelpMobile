//
//  FilterViewController.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/20/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//
import UIKit



let defaults = NSUserDefaults.standardUserDefaults()
let KEY_SORT_INDEX = "SORT_INDEX"
let KEY_DISTANCE = "DISTANCE"
let KEY_DEALS = "DEALS_INDEX"
let KEY_CATEGORIES = "CATEGORIES_ARRAY"
let KEY_SUBCATEGORIES = "SUBCATEGORIES"

var filter_sort_index = 0
var filter_distance = 10.0
var filter_deals = 0

var filter_changed : Bool?


class FilterViewController: UIViewController {
    
 
    
    let categories = ["restaurants", "bars"]
    let subcategories: Array<Array<String>> = [
          ["brazilian", "british", "cambodian", "caribbean", "chinese", "french", "italian", "japanese"],
          ["beerbar", "cocktailbars", "sportsbars", "wine_bars"]
        ]
    let categories_display = ["Restaurants", "Bars"]
    let subcategories_display: Array<Array<String>> = [
        ["Brazilian", "British", "Cambodian", "Caribbean", "Chinese", "French", "Italian", "Japanese"],
        ["Beer bar", "Cocktail Bars", "Sports Bars", "Wine Bars"]
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func searchClicked(sender: AnyObject) {
        //NSLog("click Search")
        
        filter_changed = true
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    @IBAction func cancelFilterChanges(sender: AnyObject) {
        filter_changed = false
        self.navigationController?.popToRootViewControllerAnimated(true)    }

 
}
