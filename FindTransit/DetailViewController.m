//
//  DetailViewController.m
//  FindTransit
//
//  Created by Erik Hoversten on 18.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()

@property (nonatomic, strong) IBOutlet UITableView *trainTableView;

@end

@implementation DetailViewController

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Nearest Metro's: %lu", (unsigned long)_nearStation.count);
    return _nearStation.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSArray *trainLine = [_nearStation objectForKey:@"train"];
    
    cell.textLabel.text = [(NSDictionary *)[trainLine objectAtIndex:indexPath.row] objectForKey:@"line"];
    cell.detailTextLabel.text = [(NSDictionary *)[trainLine objectAtIndex:indexPath.row] objectForKey:@"destination"];
    
    //    cell.detailTextLabel.text = [trainLine objectForKey:@"min"];
    //    cell.textLabel.text = [_nearStation objectForKey:@"line"];
    //    cell.detailTextLabel.text = [_nearStation objectForKey:@"min"];
    //    cell.textLabel.text = [(NSDictionary *)json objectForKey:@"station"] ];
    
    return cell;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _goSearch = _appDelegate.goSearch;
    _goSearch = [SearchManager shareSearch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Receiving: %@", _nearStation);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
