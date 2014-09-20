//
//  YelpAPIClient.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/20/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//


enum SORT_MODE: Int {
    case BEST_MATCHED = 0
    case DISTANCE = 1
    case HIGHEST_RATED = 2
}

enum DEAL_FILTER: Int {
    case YES = 1
    case NO = 0
}


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
    
    func searchWithTerm(term: String, category_filter: String, sort_mode: Int, deals_filter: Int,
        success: (AFHTTPRequestOperation!, AnyObject!) -> Void,
        failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
            
        var parameters = [
            "term": term,
            "location": "San Francisco"
           , "category_filter": category_filter
           , "sort": sort_mode
           , "deals_filter": deals_filter
            ]
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}
