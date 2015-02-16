//
//  ITTextField.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/28/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITProperty.h"

typedef void (^CompletionBlock)(id newValue);
typedef void (^TerminationBlock)();
typedef void (^ActivationBlock)(CompletionBlock completionBlock, TerminationBlock terminationBlock);

@protocol ITDisplayErrorMessageDelegate <NSObject>
- (void)displayErroMessageAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeErrorMessageAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ITTextField : UITextField <UITextFieldDelegate>
@property (nonatomic, weak) id <ITDisplayErrorMessageDelegate> displayMessageDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ITProperty *representedObject;
@property (nonatomic, copy) ActivationBlock activationBlock;
@property (nonatomic, copy) CompletionBlock completionBlock;
@property (nonatomic, copy) TerminationBlock terminationBlock;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIColor *errorTextColor;
@property (nonatomic, strong) UIButton *errorButton;
@property (nonatomic, strong) UILabel *floatingPlaceHolderLabel;
@property (nonatomic) BOOL isErrorMessageDisplayed;
@property (nonatomic) BOOL shouldActivateNextTextFieldOnReturn;
@property (nonatomic) BOOL shouldActivationBlockPersist;

- (void)displayErrorButton;

- (void)updateCompletionBlock:(CompletionBlock)completion;
- (void)updateTerminationBlock:(TerminationBlock)terminationBlock;
- (void)updateActivationBlock:(ActivationBlock) activationBlock;

@end
