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
#import <objc/runtime.h>

@interface ITValidationRule ()

@end

static NSString *const kWildcard = @"%@";

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
    minimumLengthRule.errorMessageTemplate = @"Text must be at least %@ characters";
    minimumLengthRule.errorMessageParameters = @[@"minimumLength"];
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

/**
 *  Creates a string from the template inserting wildcards at the specifier. The reason for this method is to create the string at runtime with the specified properties.
 */
- (NSString *)errorMessage {
    NSArray *stringArray = [self.errorMessageTemplate componentsSeparatedByString:kWildcard];
    if (stringArray.count != self.errorMessageParameters.count + 1) {
        return nil;
    }
    
    __block NSString *completedString = stringArray.firstObject;
    blockVar(self, weakSelf);
    [self.errorMessageParameters enumerateObjectsUsingBlock:^(NSString *wildcard, NSUInteger index, BOOL *stop) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic pop
    
        
        SEL selector = NSSelectorFromString(wildcard);
        IMP imp = [weakSelf methodForSelector:selector];
        
        NSString *insertValue = @"";
        id value;
        
        if ([weakSelf respondsToSelector:selector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [[weakSelf class] instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:weakSelf];
            [invocation invoke];
            void *returnValue;
            [invocation getReturnValue:&returnValue];
        }
        
        if ([weakSelf respondsToSelector:selector]) {
            Method method = class_getInstanceMethod([weakSelf class], selector);
            char *returnType = method_copyReturnType(method);
//            NSString* propertyType = [NSString stringWithFormat:@"%s", returnType];
            char character = returnType[0];
            NSString *type;
            NSNumber *number;
            switch (character){
                    
                case 'd': {
                    //type = @"double";
                    double (*func)(id, SEL) = (void *)imp;
                    func(weakSelf, selector);
                    number = [NSNumber numberWithDouble:func(weakSelf, selector)];
                    break;
                }
                case 'i': {
                    //type = @"int";
                    int (*func)(id, SEL) = (void *)imp;
                    func(weakSelf, selector);
                    number = [NSNumber numberWithDouble:func(weakSelf, selector)];
                    break;
                }
                    break;
                case 'f': {
                    type = @"float";
                    int (*func)(id, SEL) = (void *)imp;
                    func(weakSelf, selector);
                    number = [NSNumber numberWithDouble:func(weakSelf, selector)];
                    
                    break;
                }
//                case 'c': type = @"BOOL"; break;
//                case 's': type = @"short"; break;
                case 'l': {
                    long (*func)(id, SEL) = (void *)imp;
                    func(weakSelf, selector);
                    number = [NSNumber numberWithLong:func(weakSelf, selector)];
                    type = @"long";
                    break;
                }
                case 'q': {
                    long long (*func)(id, SEL) = (void *)imp;
                    func(weakSelf, selector);
                    number = [NSNumber numberWithLongLong:func(weakSelf, selector)];
                    type = @"long long";
                    break;
                }
//
//                case 'I': type = @"unsigned"; break;
//                case 'L': type = @"unsigned long"; break;
//                case 'C': type = @"unsigned char"; break;
//                case 'S': type = @"unsigned short"; break;
//                case 'Q': type = @"unsigned long long"; break;
//                case 'B': type = @"BOOL"; break; //replacing  _Bool , change it here if you wish
//                case 'v': type = @"void"; break;
//                case '*': type = @"char*"; break;
//                case ':': type = @"SEL"; break;
//                case '#': type = @"Class"; break;
//                case '@': type = @"id"; break;
//                case '@?': type = @"id"; break;
//                case 'Vv': type = @"void"; break;
//                case 'rv': type = @"const void*"; break;
                default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    value = [weakSelf performSelector:selector];
#pragma clang diagnostic pop
                    
                };
                    
            }
            if (number) {
                insertValue = number.stringValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                insertValue = value;
            }
            completedString = [NSString stringWithFormat:@"%@%@%@", completedString, insertValue, stringArray[index + 1]];
        }

    }];

    return completedString;
}


@end
