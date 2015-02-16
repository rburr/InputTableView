//
//  ITConstants.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITConstants : NSObject

FOUNDATION_EXPORT NSString *const kTextFieldShouldReturn;

#define blockVar(object, weakObject) __weak typeof(object) weakObject = object;
#define $(...)  [NSSet setWithObjects:__VA_ARGS__, nil]
#define $$(...)  [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@end
