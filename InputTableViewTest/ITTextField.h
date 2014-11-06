//
//  ITTextField.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/28/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTextObject.h"

@protocol ITDisplayErrorMessageDelegate <NSObject>
- (void)displayErroMessageAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeErrorMessageAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ITTextField : UITextField <UITextFieldDelegate>
@property (nonatomic, weak) id <ITDisplayErrorMessageDelegate> displayMessageDelete;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ITTextObject *respresentedObject;
@property (nonatomic, copy) id (^TextFieldActivated)();
@property (nonatomic) NSNumberFormatterStyle numberFormatStyle;
@property (nonatomic, strong) UIColor *errorTextColor;
@property (nonatomic, strong) UIButton *errorButton;

- (void)displayErrorButton;

@end
