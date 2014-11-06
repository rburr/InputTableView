//
//  ITTextFieldTableView.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTextField.h"

@interface ITTextFieldTableView : UITableView <ITDisplayErrorMessageDelegate>
@property (nonatomic, strong) NSArray *textObjects;
- (void)checkAndDisplayValidationErrors;

@end
