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
    
    var bizArray : NSArray?
    
    var client: YelpAPIClient?;
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var yelpTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
            
          if let business = self.bizArray?[indexPath.row] as? NSDictionary {
            
            //println(business)
            //println(indexPath.row)
            let i : Int = indexPath.row;
            let name = business["name"] as String
            
            cell.nameLabel.text = String(i+1) + ". "+name
            
            let image_url = business["image_url"] as NSString
            let rating_img_url_small = business["rating_img_url_small"] as NSString
            
            
            
            let layer = cell.bizImageView.layer;
            layer.masksToBounds=true
            layer.cornerRadius=10.0

            cell.bizImageView.setImageWithURL(NSURL(string: image_url))
            cell.ratingImgView.setImageWithURL(NSURL(string: rating_img_url_small))
            
            
            
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
          }
        }
        
        return cell
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        searchYelp()
        return true
    }
    
    @IBAction func onTab(sender: AnyObject) {
        self.searchTextField.endEditing(true)
    }
    
    func searchYelp()
    {
        if (self.filter == nil) {
            self.filter = FilterViewController.buildFilter()
                //YelpFilter(categories: "restaurants", sort: "2", radius: "10000", deals: "0")
        }
        searchWithYelpClientAPI();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueListToFilter" {
            let filterController = segue.destinationViewController as FilterViewController
            filterController.filterDelegate = self;
        }
    }
    
    func applyFilter(filter: YelpFilter){
        self.filter = filter
        searchWithYelpClientAPI();
    }
    
    func searchWithYelpClientAPI()
    {
        if (client == nil) {
            client = YelpAPIClient(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)
        }
        
        client!.searchWithTermAndFilter(self.searchTextField.text, location: location, filter:filter!,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let data = response as Dictionary<String, AnyObject>
                self.bizArray = data["businesses"] as? NSArray
                
                self.yelpTableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("error: "+error.description);
        }

    }
 
}

