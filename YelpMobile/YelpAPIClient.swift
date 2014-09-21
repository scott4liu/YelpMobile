//
//  YelpAPIClient.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/20/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

class YelpAPIClient: BDBOAuth1RequestOperationManager {
    
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, category_filter: String, sort_mode: Int, deals_filter: Int, radius_meters: Int, location: String,
        success: (AFHTTPRequestOperation!, AnyObject!) -> Void,
        failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
            
        var parameters = [
            "term": term,
            "location": location
           , "category_filter": category_filter
           , "sort": sort_mode
           , "deals_filter": deals_filter
           , "radius_filter" : radius_meters
            ]
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
    func searchWithTermAndFilter(term: String, location: String, filter: YelpFilter,
        success: (AFHTTPRequestOperation!, AnyObject!) -> Void,
        failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
            
            var parameters = [
                "term": term,
                "location": location
                , "category_filter": filter.categories
                , "sort": filter.sort
                , "deals_filter": filter.deals
                , "radius_filter" : filter.radius
            ]
            return self.GET("search", parameters: parameters, success: success, failure: failure)
    }

    
}


struct YelpFilter {
    
    var categories: String
    var sort : String
    var radius: String
    var deals: String
    
    init(categories: String, sort : String, radius: String, deals: String)
    {
        self.categories = categories;
        self.sort = sort
        self.radius = radius
        self.deals = deals
    }
    
}
