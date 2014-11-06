//
//  ITTextObject.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITValidationRule.h"

@interface ITTextObject : NSObject
@property (nonatomic, strong) NSArray *validationRules;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) id originalValue;
@property (nonatomic, strong) id currentValue;
@property (nonatomic) BOOL isFieldClear;
@property (nonatomic) BOOL displayError;

+ (instancetype)createObjectForProperty:(NSString *)propertyName fromObject:(id)object;
- (BOOL)hasErrorMessage;

@end
