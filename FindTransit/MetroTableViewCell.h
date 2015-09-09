//
//  MetroTableViewCell.h
//  FindTransit
//
//  Created by Erik Hoversten on 22.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderedRoundedView.h"
#import "UIColor+Metro.h"

@interface MetroTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lineColorLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *destinationLabel;
@property (nonatomic, strong) IBOutlet UILabel *etaLabel;
@property (nonatomic, strong) IBOutlet BorderedRoundedView *colorCircle;

@end
