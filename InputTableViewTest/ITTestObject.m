//
//  TestObject.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITTestObject.h"

@implementation ITTestObject

+ (instancetype)testObject {
    ITTestObject *one = [ITTestObject new];
    one.firstName = @"Bob";
    one.lastName = @"Paulson";
    one.age = @46;
    one.zip = @"56328";
    one.streetOne = @"760 High Ridge";
    one.city = @"Springfield";
    one.state = @"Missouri";
    return one;
}

@end
