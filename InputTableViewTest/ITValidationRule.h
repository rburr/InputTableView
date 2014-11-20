//
//  ITValidationRule.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/30/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef BOOL (^TextShouldChangeAtRange)(UITextField *currentText, NSString *newText, NSRange range);
typedef BOOL (^ValidationError)(id currentValue);

@interface ITValidationRule : NSObject
@property (copy) TextShouldChangeAtRange textShouldChangeAtRange;
@property (copy) ValidationError validationError;
/**
 *  Error message string template.
 */
@property (nonatomic, strong) NSString *errorMessageTemplate;
/**
 *  An Array of NSStrings which should be selectors that the ITValidationRule instanceType can perform.
 */
@property (nonatomic, strong) NSArray *errorMessageParameters;
@property (nonatomic) NSInteger minimumLength;
@property (nonatomic) NSInteger maximumLength;

+ (ITValidationRule *)upperCaseOnlyRule;
+ (ITValidationRule *)lowerCaseOnlyRule;
+ (ITValidationRule *)maximumLengthRule;
+ (ITValidationRule *)minimumLengthRule;

- (NSString *)errorMessage;

@end
