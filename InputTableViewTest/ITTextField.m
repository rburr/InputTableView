//
//  ITTextField.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/28/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITTextField.h"
#import "ITConstants.h"
#import "ITCircleView.h"
#import "UIView+Frame.h"

@interface ITTextField ()
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) UIColor *originalTextColor;
@property (nonatomic) BOOL isFieldClear;
@property (nonatomic) BOOL isErrorMessageDisplayed;

@end

NSInteger kErrorButtonWidth = 21;

@implementation ITTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        self.delegate = self;
        self.numberFormatter = [NSNumberFormatter new];
        self.numberFormatter.numberStyle = NSNumberFormatterBehaviorDefault;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        [self makeErrorButton];
    }
    return self;
}

- (void)setRespresentedObject:(ITTextObject *)respresentedObject {
    _respresentedObject = respresentedObject;
    self.placeholder = respresentedObject.propertyName;
    if ([respresentedObject.originalValue isKindOfClass:[NSString class]]) {
        self.text = [self displayValue];
        self.keyboardType = UIKeyboardTypeDefault;
    } else if ([respresentedObject.originalValue isKindOfClass:[NSNumber class]]) {
        self.text = [[self displayValue] stringValue];
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
    [self hideErrorButton:!respresentedObject.displayError];
}

- (id)displayValue {
    if (self.respresentedObject.isFieldClear) {
        self.respresentedObject.currentValue = nil;
        return nil;
    }
    return (self.respresentedObject.currentValue) ?: self.respresentedObject.originalValue;
}

- (void)setNumberFormatStyle:(NSNumberFormatterStyle)numberFormatStyle {
    self.numberFormatter.numberStyle = numberFormatStyle;
}

/////////////////////////////////////////////
#pragma mark - Layout Methods
/////////////////////////////////////////////


- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect originalRect = [super clearButtonRectForBounds:bounds];
    return CGRectOffset(originalRect, -30, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y,
                      bounds.size.width - 50, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.errorButton.frame = CGRectMake(self.frame.size.width - (kErrorButtonWidth + 5), (self.frame.size.height - kErrorButtonWidth)/2, kErrorButtonWidth, kErrorButtonWidth);
    [self.errorButton setImage:[self makeErrorImage] forState:UIControlStateNormal];
}

/////////////////////////////////////////////
#pragma mark - Delegate Methods
/////////////////////////////////////////////

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hideErrorButton:YES];
    self.textColor = (self.originalTextColor) ?: self.textColor;
    self.isFieldClear = NO;
    if (self.TextFieldActivated) {
        self.respresentedObject.currentValue = self.TextFieldActivated();
        self.text = self.respresentedObject.currentValue;
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.respresentedObject.originalValue isKindOfClass:[NSString class]]) {
        self.respresentedObject.currentValue = textField.text;
    } else if ([self.respresentedObject.originalValue isKindOfClass:[NSNumber class]]) {
        self.respresentedObject.currentValue = ([self.numberFormatter numberFromString:textField.text]);
        self.respresentedObject.isFieldClear = !(self.respresentedObject.currentValue);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL shouldChangeCharacters = YES;
    for (ITValidationRule *rule in self.respresentedObject.validationRules) {
        if (rule.textShouldChangeAtRange) {
            if (!rule.textShouldChangeAtRange(textField, string, range)) {
                shouldChangeCharacters = NO;
            }
        }
    }
    return shouldChangeCharacters;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTextFieldShouldReturn object:self.indexPath];
    return YES;
}

- (void)textDidChange {
    
}

/////////////////////////////////////////////
#pragma mark - Error Messages
/////////////////////////////////////////////

- (void)makeErrorButton {
    self.errorButton = [UIButton new];
    [self.errorButton addTarget:self action:@selector(displayErrorMessage) forControlEvents:UIControlEventTouchUpInside];
    self.errorButton.hidden = YES;
    [self addSubview:self.errorButton];
}

- (UIImage *)makeErrorImage {
    CGSize buttonSize = CGSizeMake(kErrorButtonWidth, kErrorButtonWidth);
    ITCircleView *circleView = [ITCircleView new];
    [circleView setRadius:buttonSize.width];
    circleView.circleColor = [UIColor redColor];
    circleView.backgroundColor = [UIColor clearColor];
    ITCircleView *innerCircle = [ITCircleView new];
    innerCircle.backgroundColor = [UIColor clearColor];
    innerCircle.circleColor = [UIColor redColor];
    innerCircle.frame = CGRectMake(2, 2, buttonSize.height - 4, buttonSize.height - 4);
    innerCircle.layer.borderColor = [UIColor whiteColor].CGColor;
    innerCircle.layer.borderWidth = 2.0;
    innerCircle.layer.cornerRadius = (buttonSize.height-4)/2;
    UILabel *circleLabel = [UILabel new];
    circleLabel.textAlignment = NSTextAlignmentCenter;
    circleLabel.frame = CGRectMake(0, 0, innerCircle.frame.size.width, innerCircle.frame.size.height);
    circleLabel.textColor = [UIColor whiteColor];
    circleLabel.text = @"!";
    circleLabel.font = [UIFont systemFontOfSize:buttonSize.width-8];
    [circleView addSubview:innerCircle];
    [innerCircle addSubview:circleLabel];
    
    return [circleView imageValue];
}

- (void)displayErrorMessage {
    if (self.isErrorMessageDisplayed) {
        [self.displayMessageDelete removeErrorMessageAtIndexPath:self.indexPath];
        self.isErrorMessageDisplayed = NO;
    } else {
        [self.displayMessageDelete displayErroMessageAtIndexPath:self.indexPath];
        self.isErrorMessageDisplayed = YES;
    }
}

- (void)displayErrorButton {
    [self hideErrorButton:NO];
    self.originalTextColor = self.textColor;
    self.textColor = (self.errorTextColor) ?: [UIColor redColor];
}

- (void)hideErrorButton:(BOOL)hide {
    self.errorButton.hidden = hide;
    if (hide) {
        self.respresentedObject.displayError = NO;
        [self.displayMessageDelete removeErrorMessageAtIndexPath:self.indexPath];
    }
}

@end
