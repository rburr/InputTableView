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
}

- (id)representedObject {
    return [ITTestObject testObject];
}

- (ActivateBlock)editingBlockForProperty:(NSString *)property {
    if ([property isEqualToString:@"dateOfBirth"]) {
        return ^id(){

            return nil;
        };
    }
    return nil;
}

- (void)saveAction {
    [self.tableView checkAndDisplayValidationErrors];
    
    if ([self.tableView shouldUpdate]) {
        [self.tableView updateObject];
    } else {
        [self.tableView updateObject];
        
    }
}

@end
