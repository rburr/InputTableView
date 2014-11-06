//
//  ITTextFieldTableView.m
//  InputTableViewTest
//
//  Created by Ryan Burr on 10/29/14.
//  Copyright (c) 2014 Ryan Burr. All rights reserved.
//

#import "ITTextFieldTableView.h"
#import "ITErrorMessageView.h"
#import "ITTableViewCell.h"
#import "ITConstants.h"

@interface ITTextFieldTableView ()
@property (nonatomic) UIEdgeInsets originalEdgeInsets;
@property (nonatomic, strong) NSMutableArray *errorMessages;
@property (nonatomic) BOOL fieldHasError;

@end

@implementation ITTextFieldTableView

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

- (void)displayErroMessageAtIndexPath:(NSIndexPath *)indexPath {
    ITErrorMessageView *errorMessageView = [ITErrorMessageView new];
    errorMessageView.indexPath = indexPath;
    ITTableViewCell *cell = (ITTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    errorMessageView.presentingButton = cell.textField.errorButton;
    CGPoint cellPosition = [self.superview convertPoint:cell.frame.origin toView:nil];
    CGPoint buttonPosition = [cell convertPoint:cell.textField.errorButton.frame.origin toView:nil];
    errorMessageView.frame = CGRectMake(buttonPosition.x - 200, cellPosition.y - 31, 240, 30);
    [self addSubview:errorMessageView];
    [self.errorMessages addObject:errorMessageView];
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

- (BOOL)textObjectsHaveChanged {
    for (ITTextObject *object in self.textObjects) {
        if ([object.originalValue isKindOfClass:[NSString class]]) {
            if ([object.originalValue isEqualToString:object.currentValue]) {
                return YES;
            }
        }
        if ([object.originalValue isKindOfClass:[NSNumber class]]) {
            if ([object.originalValue isEqual:object.currentValue]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)checkAndDisplayValidationErrors {
    blockVar(self, weakSelf)
    [self.textObjects enumerateObjectsUsingBlock:^(ITTextObject *object, NSUInteger index, BOOL *stop) {
        if ([object hasErrorMessage]) {
            ITTableViewCell *cell = (ITTableViewCell *)[weakSelf cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell.textField displayErrorButton];
            self.fieldHasError = YES;
        }
    }];
}

- (BOOL)dataIsValidAndNeedsUpdate {
    return (!self.fieldHasError && [self textObjectsHaveChanged]);
}

@end
