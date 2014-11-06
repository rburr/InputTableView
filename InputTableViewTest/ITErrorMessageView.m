//
//  ITErrorMessageView.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 11/1/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITErrorMessageView.h"
#import "ITTriangleView.h"

@interface ITErrorMessageView ()
@property (nonatomic, strong) ITTriangleView *triangleView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation ITErrorMessageView

-(id)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.6];
        self.layer.cornerRadius = 3.0f;
        [self addTriangleView];
        [self addMessageLabel];
    }
    return self;
}

- (void)addTriangleView {
    self.triangleView = [ITTriangleView new];
    self.triangleView.backgroundColor = [UIColor clearColor];
    self.triangleView.triangleColor = [[UIColor redColor] colorWithAlphaComponent:.6];
    self.triangleView.layer.transform = CATransform3DMakeRotation((90 / 180.0 * M_PI), 0, 0, 1);
    [self addSubview:self.triangleView];
}

- (void)addMessageLabel {
    self.messageLabel = [UILabel new];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = self.messageText;
    [self addSubview:self.messageLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.messageLabel.frame = CGRectMake(-5, 2, self.frame.size.width -10, self.frame.size.height -4);
    self.triangleView.frame = CGRectMake([self triangleAnchorPoint], self.frame.size.height, 20, 10);
}

- (CGFloat)triangleAnchorPoint {
   return (self.presentingButton.frame.origin.x - self.frame.origin.x + (30 - self.presentingButton.frame.size.width)) ?: self.frame.size.width - 25;
}

@end
