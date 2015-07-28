//
//  MapViewController.h
//  FindTransit
//
//  Created by Erik Hoversten on 22.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MapViewController : UIViewController

@property (nonatomic, strong) AppDelegate    *appDelegate;


- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;

@end
