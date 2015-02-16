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
 *  @param property  The property of that is being editted.
 *  @param textField The textfield containing the property
 *
 *  @return An ActivateBlock which should return the new value for the textField.
 */
- (ActivateBlock)activationBlockForProperty:(ITProperty *)property andTextField:(ITTextField *)textField;

/**
 *  Use this block to set the value of the field. This block should set the represented object's current value and textfield's text property.
 *
 *  @param property  The property of that is being editted.
 *  @param textField The textfield containing the property
 *
 *  @return A Completion Block that will execute when indicated by the action Block.
 */
- (CompletionBlock)completionBlockForProperty:(ITProperty *)property andTextField:(ITTextField *)textField;
/**
 *  This block is perform when the textField ends editting.
 *
 *  @param property  The property of that is being editted.
 *  @param textField The textfield containing the property
 *
 *  @return A Termination Block that will execute when the textField is done editting.
 */
- (TerminationBlock)terminationBlockForProperty:(ITProperty *)property andTextField:(ITTextField *)textField;
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
- (void)scrollToTextField:(ITTextField *)textField;
- (void)scrollToTextField:(ITTextField *)textField visibleTableViewBounds:(CGRect)bounds;

@end
