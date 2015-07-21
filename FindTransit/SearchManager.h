//
//  SearchManager.h
//  TransitApp
//
//  Created by Erik Hoversten on 25.06.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>   // imported to let getDataWithSearchString know about MKCoordinateRegion

@interface SearchManager : NSObject

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;


+ (id)shareSearch;   //The "id" type specifies a reference to any Objective-C object (no matter its class).

- (void)getData;

//- (void)getDataWithSearchString:(NSString *)searchString forRegion:(MKCoordinateRegion)region;

@end

