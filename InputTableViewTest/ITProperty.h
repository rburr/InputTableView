//
//  ITTextObject.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITValidationRule.h"

@interface ITProperty : NSObject
@property (nonatomic, strong) NSOrderedSet *validationRules;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *representedProperty;
@property (nonatomic, strong) id originalValue;
@property (nonatomic, strong) id currentValue;
@property (nonatomic) Class representedPropertyClass;
@property (nonatomic) BOOL isFieldClear;
@property (nonatomic) BOOL displayError;

+ (instancetype)createFromProperty:(NSString *)propertyName ofObject:(id)object;
- (BOOL)hasErrorMessage;
- (void)addValidationRules:(NSSet *)objects;

@end
