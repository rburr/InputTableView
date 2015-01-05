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
@property (nonatomic, strong) NSSet *validationRules;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *representedProperty;
@property (nonatomic, strong) id originalValue;
@property (nonatomic, strong) id currentValue;
@property (nonatomic) Class representedPropertyClass;
@property (nonatomic) BOOL isFieldClear;
@property (nonatomic) BOOL displayError;

/**
 *  Creates an ITProperty object representing the propertyName parameter of the object specified. If a the object does not have a property corresponding to the propertyName, this method will return nil.
 *
 *  @param propertyName The Property which is represented by the ITProperty instance.
 *  @param object       The Object whose property is to be represented.
 *
 *  @return An ITProperty object which represents a property of the specified object.
 */
+ (instancetype)createFromProperty:(NSString *)propertyName ofObject:(id)object;
- (BOOL)hasErrorMessage;
- (void)addValidationRules:(NSSet *)objects;

@end
