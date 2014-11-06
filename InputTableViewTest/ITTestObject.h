//
//  TestObject.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITTestObject : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *homeOrMobilePhone;
@property (nonatomic, strong) NSString *streetOne;
@property (nonatomic, strong) NSString *streetTwo;
@property (nonatomic, strong) NSString *streetThree;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *dateOfBirth;
@property (nonatomic, strong) NSString *licenseId;
@property (nonatomic, strong) NSString *licenseState;
@property (nonatomic, strong) NSString *licenseCountry;

+ (instancetype)testObject;

@end
