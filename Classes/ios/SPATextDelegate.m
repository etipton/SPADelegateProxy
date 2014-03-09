//
//  SPATextDelegate.m
//  Spectappular
//
//  Created by Eric Tipton on 1/21/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import "SPATextDelegate.h"
#import "SPADelegateProxy.h"

@interface SPATextDelegate ()

@property UIScrollView *scrollView;
@property UIView *activeField; // keeps track of field being acted upon by user
@property CGFloat keyboardHeight;
@property UIEdgeInsets origContentInset;

- (void)scrollActiveFieldToVisible;

@end

@implementation SPATextDelegate

+ (id)delegateWithViewController:(UIViewController *)viewController
{
    return [self delegateWithOverrider:viewController];
}

- (id)initWithOverrider:(UIViewController *)viewController
{
    id proxy = [super initWithOverrider:viewController];
    self = [proxy targetDelegate];
    if (self) {
        _scrollView = (UIScrollView *)viewController.view;

        // register for keyboard notifications
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWasShown:)
            name:UIKeyboardDidShowNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillBeHidden:)
            name:UIKeyboardWillHideNotification object:nil];
    }
    return proxy;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    [self scrollActiveFieldToVisible];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // strip whitespace
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // hide keyboard
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.activeField = textView;
    [self scrollActiveFieldToVisible];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    // trim whitespace
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder]; // hide keyboard
        return NO; // Don't add the final '\n' character
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.activeField = nil;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = aNotification.userInfo;

    // UIKeyboardFrameBeginUserInfoKey doesn't take into account orientation changes so we need to convert
    CGRect keyboardFrame = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.keyboardHeight = [self.scrollView.window convertRect:keyboardFrame toView:self.scrollView].size.height;

    self.origContentInset = self.scrollView.contentInset; // used for scrolling view back to orig pos
    [self scrollActiveFieldToVisible];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.keyboardHeight = 0;

    UIEdgeInsets contentInsets = self.origContentInset; // expected to be set by keyboardWasShown method
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)scrollActiveFieldToVisible
{
    if (self.keyboardHeight <= 0) return;

    // change the inset's bottom value to self.keyboardHeight, keep the rest the same
    UIEdgeInsets origContentInset = self.origContentInset;
    CGFloat top = origContentInset.top, left = origContentInset.left, right = origContentInset.right;
    UIEdgeInsets newContentInset = UIEdgeInsetsMake(top, left, self.keyboardHeight, right);
    self.scrollView.contentInset = newContentInset;
    self.scrollView.scrollIndicatorInsets = newContentInset;

    // wait 0.1 seconds before scrolling... this will allow any other triggered animations to run first
    // (some of those animations may alter the scrollView's frame)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CGRect absoluteFrame = [self.activeField.superview convertRect:self.activeField.frame toView:self.scrollView];
        absoluteFrame.size.height += 1; // allow for a 1pt border

        [self.scrollView setContentOffset:CGPointZero animated:NO]; // effectively, scroll to top
        [self.scrollView scrollRectToVisible:absoluteFrame animated:YES]; // now scroll activeField into view
    });
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
