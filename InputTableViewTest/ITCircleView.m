//
//  ITCircleView.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/31/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITCircleView.h"

@implementation ITCircleView

- (id)initWithColor:(UIColor *)color {
    self = [super init];
    if (self) {
        _circleColor = color;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents(self.circleColor.CGColor));
    CGContextFillPath(ctx);
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self layoutIfNeeded];
}

- (void)setRadius:(CGFloat)radius {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, radius, radius);
}

@end
