//
//  ITTextField.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/28/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITProperty.h"

typedef void (^TerminationBlock)(id newValue);
typedef void (^ActivateBlock)(TerminationBlock terminationBlock);
//typedef void (^ActivateBlock)(SEL updateValue);


@protocol ITDisplayErrorMessageDelegate <NSObject>
- (void)displayErroMessageAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeErrorMessageAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ITTextField : UITextField <UITextFieldDelegate>
@property (nonatomic, weak) id <ITDisplayErrorMessageDelegate> displayMessageDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ITProperty *representedObject;
@property (nonatomic, copy) ActivateBlock textFieldActivated;
@property (nonatomic, copy) TerminationBlock terminationBlock;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIColor *errorTextColor;
@property (nonatomic, strong) UIButton *errorButton;
@property (nonatomic, strong) UILabel *floatingPlaceHolderLabel;
@property (nonatomic) BOOL isErrorMessageDisplayed;

- (void)displayErrorButton;


- (void)updateTerminationBlock:(TerminationBlock)terminationBlock;
- (void)updateTextFieldActivated:(ActivateBlock)textFieldActivated;

@end
