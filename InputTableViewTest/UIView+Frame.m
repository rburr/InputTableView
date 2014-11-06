//
//  UIView+Frame.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/31/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "UIView+Frame.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Frame)

- (void)setY:(CGFloat)newY {
    CGRect frame = self.frame;
    
    frame.origin.y = newY;
    self.frame = frame;
}

- (void)setX:(CGFloat)newX {
    CGRect frame = self.frame;
    
    frame.origin.x = newX;
    self.frame = frame;
}

- (void)centerInSuperView:(UIView *)superView {
    CGFloat newY = (superView.frame.size.height - self.frame.size.height)/2;
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

- (UIImage *)imageValue {
    BOOL opaque = self.opaque;
    self.opaque = NO;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.opaque = opaque;
    
    return img;
}

@end
