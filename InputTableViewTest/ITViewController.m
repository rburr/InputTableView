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
#import "ITTextFieldTableView.h"
#import "ITValidationRule.h"
#import "ITConstants.h"

@interface ITViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ITTextFieldTableView *tableView;
@end

@implementation ITViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [ITTextFieldTableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
}

- (NSArray *)properties {
    return @[@"firstName", @"lastName", @"age", @"homeOrMobilePhone", @"streetOne", @"streetTwo", @"streetThree", @"zip", @"city", @"state", @"country", @"dateOfBirth", @"licenseId", @"licenseState", @"licenseCountry"];
}

- (NSArray *)textObjects:(NSInteger)count {
    NSMutableArray *objects = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        NSString *property = [[self properties] objectAtIndex:i];
        ITTestObject *object = [ITTestObject testObject];
        ITTextObject *textObject = [ITTextObject createObjectForProperty:property fromObject:object];
        ITValidationRule *rule = [ITValidationRule minimumLengthRule];
        rule.minimumLength = 2;
        textObject.validationRules = @[rule];
        [objects addObject:textObject];
    }
    return [NSArray arrayWithArray:objects];
}

- (NSInteger)tableView:(ITTextFieldTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.textObjects = [self textObjects:[self properties].count];
    return [self properties].count;
}

- (UITableViewCell *)tableView:(ITTextFieldTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"ITTableViewCellIdentifer";
    ITTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [ITTableViewCell new];
    }
    cell.textField.displayMessageDelete = tableView;
    cell.textField.indexPath = indexPath;
    cell.textField.respresentedObject = [tableView.textObjects objectAtIndex:indexPath.row];    
    return cell;
}

- (void)saveAction {
    [self.tableView checkAndDisplayValidationErrors];
    
}

@end
