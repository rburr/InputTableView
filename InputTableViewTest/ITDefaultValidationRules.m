//
//  ITValidationUpperCaseOnlyRule.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 11/20/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITDefaultValidationRules.h"
#import "ITConstants.h"

@implementation ITValidationUpperCaseOnlyRule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textShouldChangeAtRange = [self makeSpecificCaseBlockForUpperCase:YES];
    }
    return self;
}

@end

@implementation ITValidationLowerCaseOnlyRule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textShouldChangeAtRange = [self makeSpecificCaseBlockForUpperCase:NO];
    }
    return self;
}

@end

@implementation ITValidationMaximumLengthRule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.errorMessageParameters = @[NSStringFromSelector(@selector(maximumLength))];
        blockVar(self, weakSelf)
        self.textShouldChangeAtRange = ^BOOL(UITextField *textField, NSString *newText, NSRange range){
            return (textField.text.length < weakSelf.maximumLength);
        };
    }
    return self;
}

@end

@implementation ITValidationMinimumLengthRule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.errorMessageTemplate = @"Text must be at least %@ characters";
        self.errorMessageParameters = @[NSStringFromSelector(@selector(minimumLength))];
        blockVar(self, weakSelf)
        self.validationError = ^BOOL(id value) {
            if ([value isKindOfClass:[NSString class]]) {
                return (((NSString *)value).length <= weakSelf.minimumLength);
            } else if ([value isKindOfClass:[NSNumber class]]) {
                //why is this < and not <= ?
                return (((NSNumber *)value).stringValue.length < weakSelf.minimumLength);
            }
            return YES;
        };
    }
    return self;
}

@end

@implementation ITValidationRequiredRule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.errorMessageTemplate = @"This field is required.";
        self.validationError = ^BOOL(id value) {
            if ([value isKindOfClass:[NSString class]]) {
                return (((NSString *)value).length == 0);
            } else if ([value isKindOfClass:[NSNumber class]]) {
                return (((NSNumber *)value).stringValue.length == 0);
            } else if ([value isKindOfClass:[NSDate class]]) {
                return !value;
            }
            return YES;
        };
    }
    return self;
}

@end


