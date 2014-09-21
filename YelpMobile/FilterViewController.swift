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


protocol FilterViewControllerDelegate {
    func applyFilter()
}

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
    
    var filterDelegate : FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func searchClicked(sender: AnyObject) {
      
        filterDelegate?.applyFilter()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    @IBAction func cancelFilterChanges(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)    }

 
}
