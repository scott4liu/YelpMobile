//
//  YelpFilter.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/21/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import Foundation

var yelpFilterSingleton : YelpFilter = YelpFilter();

class YelpFilter {
    
    var sort = SORT_MODE.BEST_MATCHED
    var distance = 10.0
    var deals = DEAL_FILTER.NO
    
    class func getFilter() -> YelpFilter {
        
        return yelpFilterSingleton;
    }
    
}

enum SORT_MODE: Int {
    case BEST_MATCHED = 0
    case DISTANCE = 1
    case HIGHEST_RATED = 2
}

enum DEAL_FILTER: Int {
    case YES = 1
    case NO = 0
}
