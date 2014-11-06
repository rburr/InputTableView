//
//  ITTriangleView.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 11/1/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITTriangleView.h"

@implementation ITTriangleView

-(void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect));  // mid right
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
    CGContextClosePath(ctx);
    
    CGContextSetFillColor(ctx, CGColorGetComponents(self.triangleColor.CGColor));
    CGContextFillPath(ctx);
}

- (void)setTriangleColor:(UIColor *)triangleColor {
    _triangleColor = triangleColor;
    [self layoutIfNeeded];
}

@end
