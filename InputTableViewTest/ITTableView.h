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

/**
 *  The Object whose properties are to be displayed in by the tableView.
 *
 *  @return The Object whose properties are to be displayed in by the tableView.
 */
- (id)representedObject;
/**
 *  An array of properties to be edited.
 *
 *  @return An array of strings representing the keys for each property.
 */
- (NSArray *)displayedProperties;
/**
 *  Use this method to further customize the validation rules and other attributes of the property.
 *
 *  @param property The property to be customized.
 */
- (void)customizeRepresentedProperty:(ITProperty *)property;

@optional
/**
 *  The block activated when a textField begins editing.
 *
 *  @param property The name of the property to be edited.
 *
 *  @return An ActivateBlock which should return the new value for the textField.
 */
- (ActivateBlock)editingBlockForProperty:(NSString *)property;
/**
 *  Use this method to furth customize the textField.
 *
 *  @param textField The textField to be costumized.
 */
- (void)customizeTextField:(ITTextField *)textField;

@end

@interface ITTableView : UITableView <ITDisplayErrorMessageDelegate>
@property (nonatomic, weak) id <ITTableViewDelegate> propertyDelegate;
- (void)checkAndDisplayValidationErrors;
- (BOOL)shouldUpdate;
- (void)updateObject;

@end
