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

let client = YelpClient(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bizArray : NSArray?

    @IBOutlet weak var yelpTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchYelp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let business = self.bizArray![indexPath.row] as NSDictionary
            cell.nameLabel.text = business["name"] as NSString
        }
        
        return cell
    }

    
    
    func searchYelp()
    {
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            //println(response)
            
            let data = response as Dictionary<String, AnyObject>
            self.bizArray = data["businesses"] as? NSArray
            
            self.yelpTableView.reloadData()
            
            println(self.bizArray![0])
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("error: "+error.description);
        }
    }
    


}

