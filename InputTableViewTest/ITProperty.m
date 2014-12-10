
//
//  ITTextObject.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITProperty.h"
#import <objc/runtime.h>
#import "ITConstants.h"

@implementation ITProperty

+ (instancetype)createFromProperty:(NSString *)propertyName ofObject:(id)object {
    ITProperty *textObject = [ITProperty new];
    id value = [object valueForKey:propertyName];
    textObject.representedProperty = propertyName;
    textObject.originalValue = value;
    textObject.currentValue = value;
    textObject.propertyName = [self formatPropertyName:propertyName];
    textObject.representedPropertyClass = [ITProperty classForProperty:propertyName fromObject:object];

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

+ (Class)classForProperty:(NSString *)property fromObject:(id)object {
    objc_property_t classProperty = class_getProperty([object class], [property UTF8String]);
    const char *propertyAttrs = property_getAttributes(classProperty);
    NSString *propertyString = [NSString stringWithUTF8String:propertyAttrs];
    if ([propertyString rangeOfString:@"@"].location != NSNotFound) {
        // '\' is an escape character, looking for ' " '
        NSArray *components = [propertyString componentsSeparatedByString:@"\""];
        // '\' is an escape character, looking for ' \ '
        NSString *propertyClass = [components[1] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        return NSClassFromString(propertyClass);
    }
    
    return nil;
}

- (void)addValidationRules:(NSSet *)newRules {
    NSMutableSet *currentRules = [self.validationRules mutableCopy];

    for (ITValidationRule *newRule in newRules) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"class == %@", [newRule class]];
        NSSet *duplicates = [self.validationRules filteredSetUsingPredicate:predicate];
        for (ITValidationRule *duplicateRule in duplicates) {
            [currentRules removeObject:duplicateRule];
        }
        [currentRules addObject:newRule];
    }
    self.validationRules = [NSSet setWithSet:currentRules];
}

@end
