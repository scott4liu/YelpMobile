//
//  ViewController.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/18/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, FilterViewControllerDelegate {
    
    let kYelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA";
    let kYelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ";
    let kYelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
    let kYelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";
    
    let location = "San Francisco"
    var filter : YelpFilter?
    
    var bizArray : Array<NSDictionary>?
    
    var client: YelpAPIClient?;
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var yelpTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* does not work for ios 7
        yelpTableView.estimatedRowHeight = 85
        yelpTableView.rowHeight = UITableViewAutomaticDimension
        */
        customizeSearchTextFld()
        
        searchYelp()
    }
    
    /*
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (filter_changed == nil || filter_changed == true) {
            searchYelp()
        }
    }
    */

    func customizeSearchTextFld()
    {
        let searchIconView = UIImageView(image: UIImage(named: "searchIcon2.png"));
        searchIconView.frame = CGRectMake(0, 0, 15, 15);
        searchIconView.contentMode = UIViewContentMode.ScaleAspectFit;
        
        self.searchTextField.leftView = searchIconView;
        self.searchTextField.leftViewMode=UITextFieldViewMode.Always;

    }

    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("didSelectRowAtIndexPath")
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.bizArray != nil {
            return self.bizArray!.count
        }
        else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.yelpTableView.dequeueReusableCellWithIdentifier("YelpMobile.TableViewCell") as YelpTableViewCell
        
        if self.bizArray != nil {
            
          if let business = self.bizArray?[indexPath.row] as NSDictionary? {
            
            //println(business)
            //println(indexPath.row)
            let i : Int = indexPath.row;
            let name = business["name"] as String
            
            cell.nameLabel.text = String(i+1) + ". "+name
            
            let rating_img_url_small = business["rating_img_url_small"] as? NSString
            if rating_img_url_small != nil {
                cell.ratingImgView.setImageWithURL(NSURL(string: rating_img_url_small!))
            }
            
            
            let layer = cell.bizImageView.layer;
            layer.masksToBounds=true
            layer.cornerRadius=10.0

            let image_url = business["image_url"] as? NSString
            
            if image_url != nil {
                cell.bizImageView.setImageWithURL(NSURL(string: image_url!))
            }
            
            
            
            if let location = business["location"] as? NSDictionary {
                if let addr = location["address"] as? NSArray? {
                    
                    if addr!.count > 0 {
                        cell.addressLabel.text = (addr![0] as NSString) +  ", " + (location["city"] as NSString)
                    } else {
                        cell.addressLabel.text = location["city"] as NSString
                    }
                }
            }
            
            let review_count = String(business["review_count"] as NSInteger)
            cell.reviewsLabel.text = review_count + " Reviews"
            
            let categories = business["categories"] as NSArray
            
            var str : String?
            for category in categories {
                if let catArray = category as? NSArray {
                    let cname = catArray[0] as NSString
                    if str != nil {
                        str = str! + ", " + cname
                    }
                    else {
                        str = cname
                    }
                }
                
            }
            
            
            cell.categoryLabel.text = str
            
            
            if (indexPath.row == (self.bizArray!.count-1) ) {
                current_offset += default_limit
                searchWithYelpClientAPI()
            }
          }
        }
        
        return cell
    }


    var current_search_term : String = ""
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        current_search_term = textField.text
        searchYelp()
        return true
    }
    
    @IBAction func onTab(sender: AnyObject) {
        self.searchTextField.endEditing(true)
        if (current_search_term != self.searchTextField.text) {
            current_search_term = self.searchTextField.text
            searchYelp()
        }
    }
    
    func searchYelp()
    {
        if (self.filter == nil) {
            self.filter = FilterViewController.buildFilter()
            
        }
        current_offset = 0
        searchWithYelpClientAPI();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueListToFilter" {
            let filterController = segue.destinationViewController as FilterViewController
            filterController.filterDelegate = self;
        }
        else if segue.identifier == "SegueListToMap" {
            let filterController = segue.destinationViewController as MapViewController
            filterController.bizArray = self.bizArray
        }

    }
    
    func applyFilter(filter: YelpFilter){
        self.filter = filter
        current_offset = 0;
        searchWithYelpClientAPI();
    }
    
    let default_limit: Int = 20;
    var current_offset: Int = 0;
    
    func searchWithYelpClientAPI()
    {
        if (client == nil) {
            client = YelpAPIClient(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)
        }
        
        client!.searchWithTermAndFilter(self.searchTextField.text, limit: default_limit, offset: current_offset, location: location, filter:filter!,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let data = response as Dictionary<String, AnyObject>
                let bizData = (data["businesses"] as? NSArray) as? Array<NSDictionary>
                
                if self.current_offset == 0 {
                    self.bizArray = bizData as Array<NSDictionary>?
                    self.yelpTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated:false)
                } else if (bizData != nil)
                {
                    for d in bizData! {
                        self.bizArray?.append(d)
                    }
                }
                
                self.yelpTableView.reloadData()
                //if self.current_offset == 0 {
                    //self.yelpTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated:true)
               // }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("error: "+error.description);
        }

    }
 
}

