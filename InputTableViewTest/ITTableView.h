//
//  ITTextFieldTableView.h
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTextField.h"
#import "ITProperty.h"

@protocol ITTableViewDelegate <NSObject, UIScrollViewDelegate>
//- (NSArray *)displayedPropertiesForObject:(id)sectionObject;
//- (NSArray *)validationRulesForProperty:(NSString *)property object:(id)sectionObject;

- (id)object;
- (NSArray *)displayedProperties;
- (void)customizeRepresentObject:(ITProperty *)property;

@optional
- (ActivateBlock)blockForProperty:(NSString *)property;
- (void)customizeTextField:(ITTextField *)textField;

@end

@interface ITTableView : UITableView <ITDisplayErrorMessageDelegate>
@property (nonatomic, weak) id <ITTableViewDelegate> propertyDelegate;
- (void)checkAndDisplayValidationErrors;
- (BOOL)shouldUpdate;
- (void)updateObject;

@end
