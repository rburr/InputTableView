//
//  ITValidationRule.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/30/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITValidationRule.h"
#import <UIKit/UIKit.h>
#import "ITConstants.h"

@interface ITValidationRule ()

@end

@implementation ITValidationRule

+ (ITValidationRule *)upperCaseOnlyRule {
    ITValidationRule *upperCaseOnlyRule = [ITValidationRule new];
    upperCaseOnlyRule.textShouldChangeAtRange = [self makeSpecificCaseBlockForUpperCase:YES];
    
    return upperCaseOnlyRule;
}

+ (ITValidationRule *)lowerCaseOnlyRule {
    ITValidationRule *lowerCaseOnlyRule = [ITValidationRule new];
    lowerCaseOnlyRule.textShouldChangeAtRange = [self makeSpecificCaseBlockForUpperCase:NO];
    
    return lowerCaseOnlyRule;
}

+ (TextShouldChangeAtRange)makeSpecificCaseBlockForUpperCase:(BOOL)upperCase {
    __block BOOL isUpperCase = upperCase;
    return ^BOOL(UITextField *textField, NSString *newText, NSRange range){
        newText = (isUpperCase) ? [newText uppercaseString] : [newText lowercaseString];
        NSMutableString *mutableText = [textField.text mutableCopy];
        [mutableText insertString:newText atIndex:range.location];
        textField.text = mutableText;
        UITextPosition *beginning = textField.beginningOfDocument;
        UITextPosition *start = [textField positionFromPosition:beginning offset:range.location+1];
        UITextPosition *end = [textField positionFromPosition:start offset:range.length];
        textField.selectedTextRange = [textField textRangeFromPosition:start toPosition:end];
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
        return NO;
    };
}

+ (ITValidationRule *)minimumLengthRule {
    ITValidationRule *minimumLengthRule = [ITValidationRule new];
    blockVar(minimumLengthRule, weakMinimunRule)
    minimumLengthRule.validationError = ^BOOL(id value) {
        if ([value isKindOfClass:[NSString class]]) {
            return (((NSString *)value).length <= weakMinimunRule.minimumLength);
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return (((NSNumber *)value).stringValue.length < weakMinimunRule.minimumLength);
        }
        return YES;
    };
    return minimumLengthRule;
}

+ (ITValidationRule *)maximumLengthRule {
    ITValidationRule *maximumLengthRule = [ITValidationRule new];
    blockVar(maximumLengthRule, weakMaximumRule)
    maximumLengthRule.textShouldChangeAtRange = ^BOOL(UITextField *textField, NSString *newText, NSRange range){
        return (textField.text.length < weakMaximumRule.maximumLength);
    };
    return maximumLengthRule;
}

@end
