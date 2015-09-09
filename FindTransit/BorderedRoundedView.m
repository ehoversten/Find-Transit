//
//  BorderedRoundedView.m
//  FindTransit
//
//  Created by Erik Hoversten on 28.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import "BorderedRoundedView.h"

@implementation BorderedRoundedView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.borderWidth    = 2;
        self.borderColor    = [UIColor blackColor];
        self.cornerRadious  = 10;
        
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [self customInit];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}


- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit {
    
    
    self.layer.cornerRadius = self.cornerRadious;
    self.layer.borderWidth = self.borderWidth;
    
    if (self.cornerRadious > 0) {
        self.layer.masksToBounds = YES;
    }
    
}


@end
