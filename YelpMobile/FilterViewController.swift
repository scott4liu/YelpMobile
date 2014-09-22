//
//  FilterViewController.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/20/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//
import UIKit


/*
let defaults = NSUserDefaults.standardUserDefaults()
*/

protocol FilterViewControllerDelegate {
    func applyFilter(filter: YelpFilter)
}

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

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var filterTableView: UITableView!
    
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
        singleSelect: true,
        selections: [false]
    )

    
    
    var sections: Array<Section>?
    
    func buildFilterString(index: Int) -> String {
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
    
    func buildFilter() -> YelpFilter
    {
        
        return YelpFilter(categories: buildFilterString(0), sort: buildFilterString(1), radius: buildFilterString(2), deals: buildFilterString(3))
    }
    
    
    var filterDelegate : FilterViewControllerDelegate?
    
    override func loadView() {
        sections = [section1, section2, section3, section4]
        super.loadView()
    }
    
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
        NSLog("didSelectRowAtIndexPath")
        let selection = sections![indexPath.section].selections[indexPath.row];
        sections![indexPath.section].selections[indexPath.row] = !selection;
        self.filterTableView.reloadData()
    }
    
    
    
    
    
    
    @IBAction func searchClicked(sender: AnyObject) {
      
        filterDelegate?.applyFilter(buildFilter())
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    @IBAction func cancelFilterChanges(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)    }

}
