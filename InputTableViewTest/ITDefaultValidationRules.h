//
//  ITValidationUpperCaseOnlyRule.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 11/20/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITValidationRule.h"

@interface ITValidationUpperCaseOnlyRule : ITValidationRule

@end

@interface ITValidationLowerCaseOnlyRule : ITValidationRule

@end

@interface ITValidationMaximumLengthRule : ITValidationRule
@property (nonatomic) NSInteger maximumLength;

@end

@interface ITValidationMinimumLengthRule : ITValidationRule
@property (nonatomic) NSInteger minimumLength;

@end

@interface ITValidationRequiredRule : ITValidationRule

@end