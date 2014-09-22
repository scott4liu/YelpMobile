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
    
    var filterDelegate : FilterViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* does not work for ios 7
        filterTableView.estimatedRowHeight = 40
        filterTableView.rowHeight = UITableViewAutomaticDimension
        */
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections![section].title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections![section].currentIndex < 0 {
            return sections![section].rowsDisplay.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.filterTableView.dequeueReusableCellWithIdentifier("YelpMobile.FilterTableCell") as FilterTableViewCell
        
        var index = sections![indexPath.section].currentIndex
        if index < 0 {
            index = indexPath.row
        }
        cell.itemNameLabel.text = sections![indexPath.section].rowsDisplay[index]
        cell.itemSwitch.on = sections![indexPath.section].selections[index]
        //cell.itemSwitch.setOn(sections![indexPath.section].selections[index], animated: true)
        return cell;

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("didSelectRowAtIndexPath")
        
        var index = sections![indexPath.section].currentIndex
        if index < 0 {
            index = indexPath.row
        }
        
        let oldChoice = sections![indexPath.section].selections[index];
        
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
            
            if (sections![indexPath.section].currentIndex < 0 ) {
                sections![indexPath.section].currentIndex = index
            }
            else
            {
                sections![indexPath.section].currentIndex = -1
            }
            
            self.filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
            
        } else {
            sections![indexPath.section].selections[index] = !oldChoice;
            self.filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
        }
        
        //self.filterTableView.reloadData()
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
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
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
    var currentIndex: Int  //row index to display, -1: show all
    
    init(title: String, rowsDisplay: Array<String>, rowsValue: Array<String>, singleSelect: Bool, selections: Array<Bool>, currentIndex: Int )
    {
        self.title = title
        self.rowsDisplay = rowsDisplay
        self.rowsValue = rowsValue
        self.singleSelect = singleSelect
        self.selections = selections
        self.currentIndex = currentIndex
    }
}


let section1 = Section(title: "Categories",
    rowsDisplay: ["Restaurants", "Bars", "Coffee & Tea"],
    rowsValue: ["restaurants", "bars", "coffee"],
    singleSelect: false,
    selections: [true, false, false],
    currentIndex: -1
)

let section2 = Section(title: "Sort",
    rowsDisplay: ["Best Match", "Distance", "Rating"],
    rowsValue: ["0", "1", "2"],
    singleSelect: true,
    selections: [true, false, false],
    currentIndex: 0
)

let section3 = Section(title: "Distance",
    rowsDisplay: ["Auto", "0.3 miles", "1 mile", "5 miles", "10 miles"],
    rowsValue: ["", "482", "1609", "8047", "16093"],
    singleSelect: true,
    selections: [true, false, false, false, false],
    currentIndex: 0

)

let section4 = Section(title: "Deals",
    rowsDisplay: ["Deals On"],
    rowsValue: ["1"],
    singleSelect: false,
    selections: [false],
    currentIndex: -1
)

var sections: Array<Section>? = [section1, section2, section3, section4]


