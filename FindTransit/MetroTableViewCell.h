//
//  MetroTableViewCell.h
//  FindTransit
//
//  Created by Erik Hoversten on 22.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetroTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lineColorLabel;
//@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *destinationLabel;
@property (nonatomic, strong) IBOutlet UILabel *etaLabel;

@end
