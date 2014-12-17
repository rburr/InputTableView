//
//  ViewController.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/28/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITViewController.h"
#import "ITTableViewCell.h"
#import "ITTestObject.h"
#import "ITTableView.h"
#import "ITDefaultValidationRules.h"
#import "ITConstants.h"
#import <objc/runtime.h>

@interface ITViewController () <ITTableViewDelegate>
@property (nonatomic, strong) ITTableView *tableView;
@end

@implementation ITViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [ITTableView new];
    self.tableView.propertyDelegate = self;
    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
}

- (NSArray *)displayedProperties {
    return @[@"firstName", @"lastName", @"age", @"homeOrMobilePhone", @"streetOne", @"streetTwo", @"streetThree", @"zip", @"city", @"state", @"country", @"dateOfBirth", @"licenseId", @"licenseState", @"licenseCountry", @"powerLevel"];
}

- (void)customizeRepresentedProperty:(ITProperty *)property {
    if ([property.originalValue isKindOfClass:[NSString class]] && ((NSString *)property.originalValue).length > 0) {
        ITValidationMinimumLengthRule *minimumLengthRule = [[ITValidationMinimumLengthRule alloc] init];
        minimumLengthRule.minimumLength = 2;
        ITValidationRequiredRule *requiredRule = [[ITValidationRequiredRule alloc] init];
        property.validationRules = $(minimumLengthRule, requiredRule);
    }
    if (property.representedPropertyClass == [NSDate class]) {
        ITValidationRequiredRule *requiredRule = [[ITValidationRequiredRule alloc] init];
        property.validationRules = $(requiredRule);
    }
}

- (id)representedObject {
    return [ITTestObject testObject];
}

- (ActivateBlock)activationBlockForProperty:(ITProperty *)property andTextField:(ITTextField *)textField {
    if ([property.representedProperty isEqualToString:@"dateOfBirth"]) {
        blockVar(self, weakSelf)
        ActivateBlock dobBlock = ^(TerminationBlock terminationBlock) {
       
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view.frame = CGRectMake(0, weakSelf.view.frame.size.height - 200, weakSelf.view.frame.size.width, 200);
            __block UIDatePicker *picker = [UIDatePicker new];
            picker.datePickerMode = UIDatePickerModeDate;
            picker.frame = CGRectMake(0, 30, view.frame.size.width, 70);
            
            //Wrapper block, needs to return void and not take arguments
            void (^wrapperBlock)() = ^(){
                [view removeFromSuperview];
                //The original block I wanted to call
                terminationBlock(picker.date);
            };
            
            //Dynamic Selector name
            SEL myMethod;
            //Create the implementation
            void(*impFunct)(id, SEL, id) = (void*) imp_implementationWithBlock(wrapperBlock);
            //Add the block to the class at runtime, replace it if it already exists
            if ([weakSelf respondsToSelector:myMethod]) {
                class_replaceMethod(weakSelf.class, myMethod, (IMP)impFunct, "v@:@");
            } else {
                class_addMethod(weakSelf.class, myMethod, (IMP)impFunct, "v@:@");
            }
            
            UIButton *doneButton = [UIButton new];
            doneButton.backgroundColor = [UIColor blueColor];
            [doneButton setTitle:@"Done" forState:UIControlStateNormal];
            doneButton.frame = CGRectMake(0, 0, view.frame.size.width, 40);
            //Assign the dynamic method to the button action
            [doneButton addTarget:weakSelf action:myMethod forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:picker];
            [view addSubview:doneButton];
            [weakSelf.view addSubview:view];
        };
        return [dobBlock copy];
    }
    return nil;
}

- (TerminationBlock)terminationBlockForProperty:(ITProperty *)property andTextField:(ITTextField *)textField {
    if ([property.representedProperty isEqualToString:@"dateOfBirth"]) {
        TerminationBlock dobBlock = ^(NSDate *date) {
            property.currentValue = date;
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateStyle = NSDateFormatterShortStyle;
            textField.text = [formatter stringFromDate:date];
        };
        return [dobBlock copy];
    }
    return nil;
}

- (void)saveAction {
    [self.tableView checkAndDisplayValidationErrors];
    
    if ([self.tableView shouldUpdate]) {
        [self.tableView updateObject];
        [self.tableView reloadDataWithCurrentValues];
    } else {
        [self.tableView updateObject];
        
    }
}

@end
