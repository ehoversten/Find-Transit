//
//  DetailViewController.h
//  FindTransit
//
//  Created by Erik Hoversten on 18.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AppDelegate    *appDelegate;
@property (nonatomic, strong) NSDictionary   *nearStation;
@property (nonatomic, strong) NSArray        *metroArray;

@end
