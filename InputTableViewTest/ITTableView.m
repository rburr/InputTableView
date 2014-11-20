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

@interface ITTableView ()
//@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) NSArray *objectProperties;
@property (nonatomic) UIEdgeInsets originalEdgeInsets;
@property (nonatomic, strong) NSMutableArray *errorMessages;
@property (nonatomic) BOOL fieldHasError;

@end

@implementation ITTableView

- (id)init {
    self = [super init];
    if (self) {
        self.errorMessages = [NSMutableArray new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activateNextTextField:) name:kTextFieldShouldReturn object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)displayErroMessageAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ITErrorMessageView *errorMessageView = [ITErrorMessageView new];
    errorMessageView.indexPath = indexPath;
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
    if (buttonPosition.y - self.contentInset.top > (15 + paragraphRect.size.height)) {
        //switch view to bottom
    }
    
    errorMessageView.frame = CGRectMake(buttonPosition.x - 200, cellPosition.y - (15 + paragraphRect.size.height), messageViewWidth, paragraphRect.size.height + 10);
    [self addSubview:errorMessageView];
    [self.errorMessages addObject:errorMessageView];
}


- (NSString *)errorMessageList:(NSIndexPath *)indexPath {
    ITProperty *textObject = self.textObjects[indexPath.row];
    NSString *errorList = @"";
    for (ITValidationRule *rule in textObject.validationRules) {
        errorList =  (errorList.length > 0) ? [NSString stringWithFormat:@"%@\n%@", errorList, [rule errorMessage]] : [rule errorMessage];
    }
    return errorList;
}

- (void)removeErrorMessageAtIndexPath:(NSIndexPath *)indexPath {
    ITErrorMessageView *viewToBeRemoved;
    for (ITErrorMessageView *view in self.errorMessages) {
        if (view.indexPath == indexPath) {
            viewToBeRemoved = view;
        }
    }
    [viewToBeRemoved removeFromSuperview];
}

- (void)checkAndDisplayValidationErrors {
    [self endEditing:YES];
    blockVar(self, weakSelf)
    [self.textObjects enumerateObjectsUsingBlock:^(ITProperty *object, NSUInteger index, BOOL *stop) {
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
    for (ITProperty *object in self.textObjects) {
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
    for (ITProperty *textObject in self.textObjects) {
        [self.object setValue:textObject.currentValue forKey:textObject.representedProperty];
    }
}

- (void)reloadData {
    //Should force the reload using the current set of textObjects
    [super reloadData];
}

@end
