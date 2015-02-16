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
 *  Priority indicates where the rule will be placed in the respective ITProperty's NSOrderedSet *validationRules. Rules with a higher priority will be compared against first and if the rule does not pass validation, it will prevent rules of a lower priority from being evaluated. The default value for priority is 10.
 */
@property (nonatomic) NSInteger priority;

/**
 *  Error message string template.
 */
@property (nonatomic, strong) NSString *errorMessageTemplate;
/**
 *  An Array of strings that are represent selectors which the ITValidationRule instanceType can perform.
 */
@property (nonatomic, strong) NSArray *errorMessageParameters;

- (NSString *)errorMessage;

// Subclass methods
- (TextShouldChangeAtRange)makeSpecificCaseBlockForUpperCase:(BOOL)upperCase;

@end
