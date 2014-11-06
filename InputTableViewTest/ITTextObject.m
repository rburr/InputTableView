
//
//  ITTextObject.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITTextObject.h"
#import <objc/runtime.h>
#import "ITConstants.h"

@implementation ITTextObject

+ (instancetype)createObjectForProperty:(NSString *)propertyName fromObject:(id)object {
    ITTextObject *textObject = [ITTextObject new];
    textObject.originalValue = [object valueForKey:propertyName];
    textObject.propertyName = [self formatPropertyName:propertyName];

    return textObject;
}

+ (NSString *)formatPropertyName:(NSString *)camelCaseString {
    NSMutableString *spacedString = [@"" mutableCopy];
    for (int i = 0; i < [camelCaseString length]; i++) {
        unichar character = [camelCaseString characterAtIndex:i];
        if ([[NSCharacterSet alphanumericCharacterSet] characterIsMember:character]) {
            NSString *letter = [NSString stringWithFormat: @"%C", character];
            if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:character]) {
                [spacedString appendString:[NSString stringWithFormat:@" %@", letter]];
            } else {
                [spacedString appendString:letter];
            }
        }
    }
    
    return [spacedString capitalizedString];
}

- (BOOL)hasErrorMessage {
    BOOL hasError = NO;
    for (ITValidationRule *rule in self.validationRules) {
        if (rule.validationError) {
            id comparisonObject = (self.currentValue) ?:self.originalValue;
            if (rule.validationError(comparisonObject)) {
                hasError = YES;
                self.displayError = YES;
            }
        }
    }
    return hasError;
}

@end
