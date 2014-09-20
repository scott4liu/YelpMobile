//
//  ViewController.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/18/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit


let kYelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA";
let kYelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ";
let kYelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
let kYelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

let client = YelpAPIClient(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var bizArray : NSArray?

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var yelpTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        customizeSearchTextFld()
        
        searchYelp("Thai")
        
    }

    func customizeSearchTextFld()
    {
        let searchIconView = UIImageView(image: UIImage(named: "searchIcon2.png"));
        searchIconView.frame = CGRectMake(0, 0, 15, 15);
        searchIconView.contentMode = UIViewContentMode.ScaleAspectFit;
        
        self.searchTextField.leftView = searchIconView;
        self.searchTextField.leftViewMode=UITextFieldViewMode.Always;

    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("didSelectRowAtIndexPath")
        
        
    }
    
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
            
            cell.nameLabel.text = business["name"] as NSString
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
        searchYelp(textField.text)
        return true
    }
    
    @IBAction func onTab(sender: AnyObject) {
        self.searchTextField.endEditing(true)
    }
    
    func searchYelp(searchTerm: String)
    {
        let category = "restaurants"
        let sort = SORT_MODE.HIGHEST_RATED.toRaw()
        let deals = DEAL_FILTER.NO.toRaw()
        
        client.searchWithTerm(searchTerm,
            category_filter: category,
            sort_mode: sort,
            deals_filter: deals,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let data = response as Dictionary<String, AnyObject>
                self.bizArray = data["businesses"] as? NSArray
                
                self.yelpTableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("error: "+error.description);
        }
        
    }
    


}

