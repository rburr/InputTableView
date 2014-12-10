//
//  ITTextField.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/28/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITProperty.h"

typedef id (^ActivateBlock)();

@protocol ITDisplayErrorMessageDelegate <NSObject>
- (void)displayErroMessageAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeErrorMessageAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ITTextField : UITextField <UITextFieldDelegate>
@property (nonatomic, weak) id <ITDisplayErrorMessageDelegate> displayMessageDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ITProperty *respresentedObject;
@property (nonatomic, copy) ActivateBlock textFieldActivated;
@property (nonatomic) NSNumberFormatterStyle numberFormatStyle;
@property (nonatomic, strong) UIColor *errorTextColor;
@property (nonatomic, strong) UIButton *errorButton;
@property (nonatomic, strong) UILabel *floatingPlaceHolderLabel;

- (void)displayErrorButton;

@end
