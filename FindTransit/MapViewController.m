//
//  MapViewController.m
//  FindTransit
//
//  Created by Erik Hoversten on 22.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

#pragma mark - Gesture Methods

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}



#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _goSearch = _appDelegate.goSearch;
    _goSearch = [SearchManager shareSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
