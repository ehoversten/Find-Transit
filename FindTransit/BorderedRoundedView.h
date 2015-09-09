//
//  BorderedRoundedView.h
//  FindTransit
//
//  Created by Erik Hoversten on 28.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface BorderedRoundedView : UIView

@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadious;
//@property (nonatomic) IBInspectable CGColorRef boundingColor;
@property (nonatomic) IBInspectable UIColor *borderColor;


@end
