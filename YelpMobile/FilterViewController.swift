//
//  FilterViewController.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/20/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//
import UIKit


protocol FilterViewControllerDelegate {
    func applyFilter(filter: YelpFilter)
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var filterTableView: UITableView!
    
    class func buildFilterString(index: Int) -> String {
        let section = sections![index]
        var str : String? = nil;
        for var i = 0; i < section.selections.count; ++i {
            if (section.selections[i] ) {
                if str != nil {
                    str = str! + "," + section.rowsValue[i]
                }
                else {
                    str = section.rowsValue[i]
                }
            }
        }
        
        //println(str)
        
        return str ?? ""
        
    }
    
    class func buildFilter() -> YelpFilter
    {
        
        return YelpFilter(categories: buildFilterString(0), sort: buildFilterString(1), radius: buildFilterString(2), deals: buildFilterString(3))
    }
    
    
    var filterDelegate : FilterViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections![section].title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections![section].rowsDisplay.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.filterTableView.dequeueReusableCellWithIdentifier("YelpMobile.FilterTableCell") as FilterTableViewCell
        cell.itemNameLabel.text = sections![indexPath.section].rowsDisplay[indexPath.row]
        cell.itemSwitch.on = sections![indexPath.section].selections[indexPath.row]
        //cell.itemSwitch.setOn(sections![indexPath.section].selections[indexPath.row], animated: true)
        return cell;

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("didSelectRowAtIndexPath")
        let oldChoice = sections![indexPath.section].selections[indexPath.row];
        
        if sections![indexPath.section].singleSelect {
            if (oldChoice != true) {
                for (var i=0; i<sections![indexPath.section].selections.count; ++i) {
                    if (i == indexPath.row) {
                        sections![indexPath.section].selections[i] = true
                    } else {
                        sections![indexPath.section].selections[i] = false
                    }
                }
            }
            
        } else {
            sections![indexPath.section].selections[indexPath.row] = !oldChoice;
        }
        
        self.filterTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
    
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = sections![indexPath.section]
        if section.singleSelect {
            if !section.selections[indexPath.row] {
                return 0;
            }
        }
        
        return 40;
    }
    */
    
    
    
    
    @IBAction func searchClicked(sender: AnyObject) {
      
        filterDelegate?.applyFilter(FilterViewController.buildFilter())
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    @IBAction func cancelFilterChanges(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)    }

}

/*****************************************************************************************
    define Filter and FilterTableView Datasource Data structure here
    
    To Do: store user selections in NSUserDefaults
           let defaults = NSUserDefaults.standardUserDefaults()
******************************************************************************************/

struct Section {
    var title: String
    var rowsDisplay: Array<String>
    var rowsValue: Array<String>
    var singleSelect: Bool
    var selections: Array<Bool>
    
    init(title: String, rowsDisplay: Array<String>, rowsValue: Array<String>, singleSelect: Bool, selections: Array<Bool>)
    {
        self.title = title
        self.rowsDisplay = rowsDisplay
        self.rowsValue = rowsValue
        self.singleSelect = singleSelect
        self.selections = selections
    }
}


let section1 = Section(title: "Categories",
    rowsDisplay: ["Restaurants", "Bars", "Coffee & Tea"],
    rowsValue: ["restaurants", "bars", "coffee"],
    singleSelect: false,
    selections: [true, false, false]
)

let section2 = Section(title: "Sort",
    rowsDisplay: ["Best Match", "Distance", "Rating"],
    rowsValue: ["0", "1", "2"],
    singleSelect: true,
    selections: [true, false, false]
)

let section3 = Section(title: "Distance",
    rowsDisplay: ["Auto", "0.3 miles", "1 mile", "5 miles", "10 miles"],
    rowsValue: ["", "482", "1609", "8047", "16093"],
    singleSelect: true,
    selections: [true, false, false, false, false]
)

let section4 = Section(title: "Deals",
    rowsDisplay: ["Deals On"],
    rowsValue: ["1"],
    singleSelect: false,
    selections: [false]
)

var sections: Array<Section>? = [section1, section2, section3, section4]


