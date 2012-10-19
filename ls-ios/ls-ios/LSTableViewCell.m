//
//  LSTableViewCell.m
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

#import "LSTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LSTableViewCell
+ (CGFloat)cellHeight
{
    return 100.f;
}

- (void)drawRect:(CGRect)rect
{   [super drawRect:rect];
    
    CALayer *layer = [self.image layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    layer = [self.avatar layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
}
@end
