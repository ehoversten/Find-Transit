//
//  SearchManager.m
//  TransitApp
//
//  Created by Erik Hoversten on 25.06.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import "SearchManager.h"

@implementation SearchManager

// expects to return an Object, of what TYPE we do not speficically know.
+ (id)shareSearch {
    static SearchManager *shareSearch = nil;  // limits the scope of object SearchAssist to the current SearchAssist.m file / or class(????)
    @synchronized(self) {    // for Multithreading, restricts this code to only be ran on one(this?) thread
        if (shareSearch == nil) {   // if shareSearch does not exist, create it
            shareSearch = [[self alloc] init];
        }
        return shareSearch;
    }
}

- (void)getData {
    _dataArray = @[@"Junk",@"Other Junk"];
}

//- (void)getDataWithSearchString:(NSString *)searchString forRegion:(MKCoordinateRegion)region {
//    NSLog(@"Search Requested");
//    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
//    request.naturalLanguageQuery = searchString;
//    request.region = region;
//    // this runs in the background until listener knows about it
//    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
//    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//        if (response.mapItems.count == 0) {
//            NSLog(@"Got Nothing");
//        } else {
//            _dataArray = response.mapItems;     // load _dataArray
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultsDoneNotification" object:nil];
//        }
//        
//    }];
//    
//}

@end

