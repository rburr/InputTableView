//
//  ITCircleView.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/31/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITCircleView : UIView
@property (nonatomic, strong) UIColor *circleColor;

- (id)initWithColor:(UIColor *)color;
- (void)setRadius:(CGFloat)radius;

@end
