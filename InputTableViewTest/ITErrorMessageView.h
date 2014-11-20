//
//  ITErrorMessageView.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 11/1/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITErrorMessageView : UIView
@property (nonatomic, strong) UIButton *presentingButton;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
