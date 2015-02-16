//
//  ITTextFieldTableView.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITTableView.h"
#import "ITErrorMessageView.h"
#import "ITTableViewCell.h"
#import "ITConstants.h"

@interface ITTableView () <UITableViewDataSource, UITableViewDelegate>
//@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) NSArray *objectProperties;
@property (nonatomic) UIEdgeInsets originalEdgeInsets;
@property (nonatomic) NSValue *originalContentOffset;
@property (nonatomic, strong) NSMutableArray *errorMessages;
@property (nonatomic) BOOL fieldHasError;
@property (nonatomic, strong) id representedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic) BOOL shouldReloadDataWithCurrentValues;

@end

@implementation ITTableView

- (id)init {
    self = [super init];
    if (self) {
        self.errorMessages = [NSMutableArray new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activateNextTextField:) name:kTextFieldShouldReturn object:nil];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/////////////////////////////////////////////
#pragma mark - Formatters
/////////////////////////////////////////////

- (NSDateFormatter *)tableViewDateFormatter {
    if (self.dateFormatter) {
        return self.dateFormatter;
    } else {
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
        return self.dateFormatter;
    }
}

- (NSNumberFormatter *)tableViewNumberFormatter {
    if (self.numberFormatter) {
        return self.numberFormatter;
    } else {
        self.numberFormatter = [NSNumberFormatter new];
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        return self.numberFormatter;
    }
}


/////////////////////////////////////////////
#pragma mark - TableView Delegate and Datasource
/////////////////////////////////////////////

- (NSArray *)properties {
    NSMutableArray *properties = [NSMutableArray new];
    for (NSString *property in [self.propertyDelegate displayedProperties]) {
        if ([self.representedObject respondsToSelector:NSSelectorFromString(property)]) {
            [properties addObject:property];

        }
    }
    return [properties copy];
}

- (NSArray *)createRepresentedProperties:(NSArray *)properties {
    NSMutableArray *objects = [NSMutableArray new];
    for (int i = 0; i < properties.count; i++) {
        NSString *property = [properties objectAtIndex:i];
        if (self.representedObject) {
            ITProperty *representedProperty = [ITProperty createFromProperty:property ofObject:self.representedObject];
            if (representedProperty) {
                [self.propertyDelegate customizeRepresentedProperty:representedProperty];
                [objects addObject:representedProperty];
            }
        }
    }
    return [NSArray arrayWithArray:objects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.representedObject = [self.propertyDelegate representedObject];
    return 1;
}

- (NSInteger)tableView:(ITTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *properties = [self properties];
    if (!self.shouldReloadDataWithCurrentValues) {
        tableView.objectProperties = [self createRepresentedProperties:properties];
    }
    return properties.count;
}

- (UITableViewCell *)tableView:(ITTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"ITTableViewCellIdentifer";
    ITTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [ITTableViewCell new];
    }
    cell.textField.dateFormatter = [self tableViewDateFormatter];
    cell.textField.numberFormatter = [self tableViewNumberFormatter];
    cell.textField.displayMessageDelegate = tableView;
    cell.textField.isErrorMessageDisplayed = [self isErrorMessageDisplayedAtIndexPath:indexPath];
    cell.textField.indexPath = indexPath;
    cell.textField.representedObject = [tableView.objectProperties objectAtIndex:indexPath.row];
    
    if ([tableView.propertyDelegate respondsToSelector:@selector(activationBlockForProperty:andTextField:)]) {
        [cell.textField updateTextFieldActivated:[tableView.propertyDelegate activationBlockForProperty:cell.textField.representedObject andTextField:cell.textField]];
    }
    if ([tableView.propertyDelegate respondsToSelector:@selector(completionBlockForProperty:andTextField:)]) {
        [cell.textField updateCompletionBlock:[tableView.propertyDelegate completionBlockForProperty:cell.textField.representedObject andTextField:cell.textField]];
    }
    if ([tableView.propertyDelegate respondsToSelector:@selector(terminationBlockForProperty:andTextField:)]) {
        [cell.textField updateTerminationBlock:[tableView.propertyDelegate terminationBlockForProperty:cell.textField.representedObject andTextField:cell.textField]];
    }
    return cell;
}

/////////////////////////////////////////////
#pragma mark - KeyBoard Animations
/////////////////////////////////////////////

- (void)keyBoardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSNumber *animationRate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    UIEdgeInsets contentInsets = self.contentInset;
    self.originalEdgeInsets = contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets.bottom = keyboardSize.height + 10;
    } else {
        contentInsets.bottom = keyboardSize.width + 10;
    }
    [UIView animateWithDuration:animationRate.floatValue animations: ^{
        self.contentInset = contentInsets;
        self.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    NSNumber *animationRate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:animationRate.floatValue animations: ^{
        [self setContentInset:self.originalEdgeInsets];
        [self setScrollIndicatorInsets:self.originalEdgeInsets];
    }];
}

/////////////////////////////////////////////
#pragma mark - Scroll To TextField
/////////////////////////////////////////////

- (void)scrollToTextField:(ITTextField *)textField {
    CGRect textFieldCellFrame = [self rectForRowAtIndexPath:textField.indexPath];
    [self scrollRectToVisible:textFieldCellFrame animated:YES];
}

- (void)scrollToTextField:(ITTextField *)textField visibleTableViewBounds:(CGRect)bounds {
    CGRect originalBounds = self.bounds;
    self.bounds = bounds;
    [self scrollToTextField:textField];
    self.bounds = originalBounds;
}

/////////////////////////////////////////////
#pragma mark - Tab/Next Helper
/////////////////////////////////////////////

- (void)activateNextTextField:(NSNotification *)notification {
    NSIndexPath *indexPath = notification.object;
    if ([self numberOfRowsInSection:indexPath.section] == indexPath.row + 1) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section+1];
    } else {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    }
    ITTableViewCell *cell = (ITTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}

/////////////////////////////////////////////
#pragma mark - Error Message Display
/////////////////////////////////////////////

- (BOOL)isErrorMessageDisplayedAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSPredicate *errorMessagePredicate = [NSPredicate predicateWithFormat:@"row == %i", row];
    NSMutableArray *errorMessagesAtIndexPath = [[self.errorMessages filteredArrayUsingPredicate:errorMessagePredicate] mutableCopy];
    if (errorMessagesAtIndexPath.count == 1) {
        return YES;
    } else if (errorMessagesAtIndexPath.count > 1) {
        [errorMessagesAtIndexPath removeLastObject];
        [self.errorMessages removeObjectsInArray:errorMessagesAtIndexPath];
        
        return YES;
    }
    return NO;
}

- (void)displayErroMessageAtIndexPath:(NSIndexPath *)indexPath {
    ITErrorMessageView *errorMessageView = [ITErrorMessageView new];
    [errorMessageView updateIndexPath:indexPath];
    ITTableViewCell *cell = (ITTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    errorMessageView.presentingButton = cell.textField.errorButton;
    
    NSString *messageText = [self errorMessageList:indexPath];
    CGFloat messageViewWidth = 240;
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    CGRect paragraphRect = [messageText
                            boundingRectWithSize:maximumLabelSize
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{ NSFontAttributeName : errorMessageView.messageLabel.font }
                            context:nil];
    
    
    errorMessageView.messageLabel.text = [self errorMessageList:indexPath];
    CGPoint cellPosition = [self.superview convertPoint:cell.frame.origin toView:nil];
    CGPoint buttonPosition = [cell convertPoint:cell.textField.errorButton.frame.origin toView:nil];
    errorMessageView.frame = CGRectMake(buttonPosition.x - 200, cellPosition.y - (15 + paragraphRect.size.height), messageViewWidth, paragraphRect.size.height + 10);

    if (buttonPosition.y - self.contentInset.top < (25 + paragraphRect.size.height)) {
        self.originalContentOffset = [NSValue valueWithCGPoint:self.contentOffset];
        CGRect visibleFrame = errorMessageView.frame;
        visibleFrame.origin.y -= 10;
        [self scrollRectToVisible:visibleFrame animated:YES];
    }
    
    [self addSubview:errorMessageView];
    [self.errorMessages addObject:errorMessageView];
}


- (NSString *)errorMessageList:(NSIndexPath *)indexPath {
    ITProperty *textObject = self.objectProperties[indexPath.row];
    NSString *errorList = @"";
    for (ITValidationRule *rule in textObject.validationRules) {
        errorList =  (errorList.length > 0) ? [NSString stringWithFormat:@"%@\n%@", errorList, [rule errorMessage]] : [rule errorMessage];
    }
    return errorList;
}

- (void)removeErrorMessageAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *viewsToBeRemoved = [NSMutableArray new];
    for (ITErrorMessageView *view in self.errorMessages) {
        if (view.row == indexPath.row) {
            [view removeFromSuperview];
            [viewsToBeRemoved addObject:view];
        }
    }
    [self.errorMessages removeObjectsInArray:viewsToBeRemoved];
    
    if (self.originalContentOffset) {
        [self setContentOffset:self.originalContentOffset.CGPointValue animated:YES];
        self.originalContentOffset = nil;
    }
}

- (void)checkAndDisplayValidationErrors {
    [self endEditing:YES];
    blockVar(self, weakSelf)
    [self.objectProperties enumerateObjectsUsingBlock:^(ITProperty *object, NSUInteger index, BOOL *stop) {
        if ([object hasErrorMessage]) {
            ITTableViewCell *cell = (ITTableViewCell *)[weakSelf cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell.textField displayErrorButton];
            self.fieldHasError = YES;
        } else {
            self.fieldHasError = NO;
        }
    }];
}

/////////////////////////////////////////////
#pragma mark - Property Validation and Saving
/////////////////////////////////////////////

- (BOOL)textObjectsHaveChanged {
    for (ITProperty *object in self.objectProperties) {
        if ([object.currentValue isKindOfClass:[NSString class]]) {
            if (![object.currentValue isEqualToString:object.originalValue]) {
                return YES;
            }
        }
        if ([object.currentValue isKindOfClass:[NSNumber class]]) {
            if (![object.currentValue isEqual:object.originalValue]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)shouldUpdate {
    return (!self.fieldHasError && [self textObjectsHaveChanged]);
}

- (void)updateObject {
    for (ITProperty *textObject in self.objectProperties) {
        [self.representedObject setValue:textObject.currentValue forKey:textObject.representedProperty];
    }
}

- (void)reloadDataWithCurrentValues {
    self.shouldReloadDataWithCurrentValues = YES;
    [super reloadData];
    self.shouldReloadDataWithCurrentValues = NO;
}

- (void)resetChanges {
    [super reloadData];
}

@end
