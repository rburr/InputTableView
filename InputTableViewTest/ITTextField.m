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
#import "ITDefaultValidationRules.h"

static NSString *const kActivationBlockCompleted = @"kTextFieldActivationBlockCompleted";
static NSString *const kTerminationBlockCompleted = @"kTextFieldTerminationBlockCompleted";


@interface ITTextField ()
@property (nonatomic, strong) UIColor *originalTextColor;
@property (nonatomic) BOOL isFieldClear;
@property (nonatomic) BOOL isRequiredField;
@property (nonatomic) BOOL isActivationBlockActive;

@end

NSInteger kErrorButtonWidth = 21;

@implementation ITTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        self.delegate = self;
        self.tintColor = [UIColor grayColor];
        self.floatingPlaceHolderLabel = [UILabel new];
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        [self makeErrorButton];
        [self makeFloatingLabel];
    }
    return self;
}

- (void)setRepresentedObject:(ITProperty *)respresentedObject {
    _representedObject = respresentedObject;
    self.placeholder = respresentedObject.propertyName;
    self.floatingPlaceHolderLabel.text = respresentedObject.propertyName;
    
    NSPredicate *validationRulePredicate = [NSPredicate predicateWithFormat:@"class == %@", [ITValidationRequiredRule class]];
    self.isRequiredField = ([respresentedObject.validationRules filteredSetUsingPredicate:validationRulePredicate].count > 0);
    if (self.isRequiredField) {
        [self requiredIndicator];
    }
    
    if (respresentedObject.representedPropertyClass == [NSString class]) {
        self.text = [self displayValue];
        self.keyboardType = UIKeyboardTypeDefault;
    } else if (respresentedObject.representedPropertyClass == [NSNumber class]) {
        self.text = ((NSNumber *)[self displayValue]).stringValue;
        self.keyboardType = UIKeyboardTypeDecimalPad;
    } else if (respresentedObject.representedPropertyClass == [NSDate class]) {
        self.text = [self.dateFormatter stringFromDate:[self displayValue]];
    }
    [self hideErrorButton:!respresentedObject.displayError];
}

- (id)displayValue {
    if (self.representedObject.isFieldClear) {
        self.representedObject.currentValue = nil;
        return nil;
    }
    return (self.representedObject.currentValue) ?: self.representedObject.originalValue;
}

/////////////////////////////////////////////
#pragma mark - Layout Methods
/////////////////////////////////////////////


- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect originalRect = [super clearButtonRectForBounds:bounds];
    return CGRectOffset(originalRect, -30, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y + 15, bounds.size.width - 50, bounds.size.height - 15);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.errorButton.frame = CGRectMake(self.frame.size.width - (kErrorButtonWidth + 5), (self.frame.size.height - kErrorButtonWidth)/2, kErrorButtonWidth, kErrorButtonWidth);
    [self.errorButton setImage:[self makeErrorImage] forState:UIControlStateNormal];
    self.floatingPlaceHolderLabel.frame = CGRectMake(0, 0, 200, 15);
}

/////////////////////////////////////////////
#pragma mark - Block Methods
/////////////////////////////////////////////

- (void)updateTextFieldActivated:(ActivateBlock)textFieldActivated {
    blockVar(self, weakSelf);
    if (textFieldActivated) {
    self.textFieldActivated = [^(TerminationBlock block) {
        if (block) {
            textFieldActivated(block);
        }
        weakSelf.isActivationBlockActive = YES;
    } copy];
    }
}

- (void)updateTerminationBlock:(TerminationBlock)terminationBlock {
    blockVar(self, weakSelf);
    if (terminationBlock) {
    self.terminationBlock = [^(id value) {
        terminationBlock(value);
        weakSelf.isActivationBlockActive = NO;
    } copy];
    }
}

/////////////////////////////////////////////
#pragma mark - Delegate Methods
/////////////////////////////////////////////

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hideErrorButton:YES];
    
    self.textColor = (self.originalTextColor) ?: self.textColor;
    self.floatingPlaceHolderLabel.textColor = [UIColor colorWithRed:.1 green:.2 blue:.8 alpha:1.0];
    
    self.isFieldClear = NO;
    if (self.textFieldActivated) {
        if (!self.isActivationBlockActive) {
            self.textFieldActivated(self.terminationBlock);
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.representedObject.representedPropertyClass == NSString.class) {
        self.representedObject.currentValue = textField.text;
        
    } else if (self.representedObject.representedPropertyClass == NSNumber.class) {
        self.representedObject.currentValue = ([self.numberFormatter numberFromString:textField.text]);
        self.representedObject.isFieldClear = !(self.representedObject.currentValue);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL shouldChangeCharacters = YES;
    for (ITValidationRule *rule in self.representedObject.validationRules) {
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
#pragma mark - Floating Label Methods
/////////////////////////////////////////////

- (void)makeFloatingLabel {
    self.floatingPlaceHolderLabel = [UILabel new];
    self.floatingPlaceHolderLabel.font = [UIFont systemFontOfSize:12];
    self.floatingPlaceHolderLabel.textColor = [UIColor colorWithRed:.1 green:.2 blue:.8 alpha:1.0];
    [self addSubview:self.floatingPlaceHolderLabel];
}


- (void)requiredIndicator {
    self.floatingPlaceHolderLabel.font = [UIFont boldSystemFontOfSize:self.floatingPlaceHolderLabel.font.pointSize];
    self.floatingPlaceHolderLabel.text = [NSString stringWithFormat:@"%@*", self.floatingPlaceHolderLabel.text];
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
        [self.displayMessageDelegate removeErrorMessageAtIndexPath:self.indexPath];
        self.isErrorMessageDisplayed = NO;
    } else {
        [self.displayMessageDelegate displayErroMessageAtIndexPath:self.indexPath];
        self.isErrorMessageDisplayed = YES;
    }
}

- (void)displayErrorButton {
    [self hideErrorButton:NO];
    self.originalTextColor = self.textColor;
    self.textColor = (self.errorTextColor) ?: [UIColor redColor];
    self.floatingPlaceHolderLabel.textColor = (self.errorTextColor) ?: [UIColor redColor];
}

- (void)hideErrorButton:(BOOL)hide {
    self.errorButton.hidden = hide;
    if (hide) {
        self.representedObject.displayError = NO;
        [self.displayMessageDelegate removeErrorMessageAtIndexPath:self.indexPath];
    }
}

@end
