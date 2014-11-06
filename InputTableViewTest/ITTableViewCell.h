//
//  ITTableViewCell.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/28/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTextField.h"

@interface ITTableViewCell : UITableViewCell
@property (nonatomic, strong) ITTextField *textField;

@end
