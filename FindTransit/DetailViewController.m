//
//  DetailViewController.m
//  FindTransit
//
//  Created by Erik Hoversten on 18.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "MetroTableViewCell.h"
//#import "BorderedRoundedView.h"

@interface DetailViewController ()

@property (nonatomic, strong) IBOutlet UITableView *trainTableView;
@property (nonatomic, strong) NSArray              *trainLine;
@property (nonatomic, strong) IBOutlet UILabel     *stationLabel;

@end

@implementation DetailViewController



#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _trainLine.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    MetroTableViewCell *cell = (MetroTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    _stationLabel.text = [_nearStation objectForKey:@"name"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressLabel.text = [NSString stringWithFormat:@"Address: %@ ",[_nearStation objectForKey:@"address"]];
    cell.destinationLabel.text = [(NSDictionary *)[_trainLine objectAtIndex:indexPath.row] objectForKey:@"destination"];
    cell.etaLabel.text = [NSString stringWithFormat:@"Approximate ETA: %@ min", [(NSDictionary *)[_trainLine objectAtIndex:indexPath.row] objectForKey:@"min"]];

    cell.lineColorLabel.text = [(NSDictionary *)[_trainLine objectAtIndex:indexPath.row] objectForKey:@"line"];
    
    if ([cell.lineColorLabel.text  isEqual: @"BL"]) {
        [cell.colorCircle setBackgroundColor: [UIColor metroBlueColor]];
        //[cell.lineColorLabel setBackgroundColor:[UIColor blueColor]];
    } else if ([cell.lineColorLabel.text  isEqual: @"OR"]) {
        [cell.colorCircle setBackgroundColor: [UIColor metroOrangeColor]];
        //[cell.colorCircle setBackgroundColor: [UIColor orangeColor]];
        //[cell.lineColorLabel setBackgroundColor:[UIColor orangeColor]];
    } else if ([cell.lineColorLabel.text  isEqual: @"GR"]) {
        [cell.colorCircle setBackgroundColor: [UIColor metroGreenColor]];
        //[cell.colorCircle setBackgroundColor: [UIColor greenColor]];
        //[cell.lineColorLabel setBackgroundColor:[UIColor greenColor]];
    } else if ([cell.lineColorLabel.text isEqual:@"RD"]) {
        [cell.colorCircle setBackgroundColor: [UIColor metroRedColor]];
        //[cell.colorCircle setBackgroundColor: [UIColor redColor]];
        //[cell.lineColorLabel setBackgroundColor:[UIColor redColor]];
    } else if ([cell.lineColorLabel.text isEqual:@"SV"]) {
        [cell.colorCircle setBackgroundColor: [UIColor metroSilverColor]];
        //[cell.colorCircle setBackgroundColor: [UIColor grayColor]];
        //[cell.lineColorLabel setBackgroundColor:[UIColor grayColor]];
    } else if ([cell.lineColorLabel.text isEqual:@"YW"]) {
        [cell.colorCircle setBackgroundColor: [UIColor metroYellowColor]];
        //[cell.colorCircle setBackgroundColor: [UIColor yellowColor]];
        //[cell.lineColorLabel setBackgroundColor:[UIColor yellowColor]];
    } else if ([cell.lineColorLabel.text isEqual:@"--"]) {
        [cell.lineColorLabel setBackgroundColor:[UIColor blackColor]];
    }
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _trainLine = [_nearStation objectForKey:@"train"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
