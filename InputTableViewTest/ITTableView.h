//
//  ITTextFieldTableView.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTextField.h"

@protocol ITTableViewDelegate <NSObject, UIScrollViewDelegate>
//- (NSArray *)displayedObjects;
//- (NSArray *)displayedPropertiesForObject:(id)sectionObject;
//- (NSArray *)validationRulesForProperty:(NSString *)property object:(id)sectionObject;

- (NSArray *)displayedProperties;
- (NSArray *)validationRulesForProperty:(NSString *)property;

@optional
- (ActivateBlock)blockForProperty:(NSString *)property;
- (void)customizeTextField:(ITTextField *)textField;

@end

@interface ITTableView : UITableView <ITDisplayErrorMessageDelegate>
@property (nonatomic, strong) NSArray *textObjects;
@property (nonatomic, strong) id object;
- (void)checkAndDisplayValidationErrors;
- (BOOL)shouldUpdate;
- (void)updateObject;

@end
