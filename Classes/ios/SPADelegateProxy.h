//
//  SPADelegateProxy.h
//  Spectappular
//
//  Created by Eric Tipton on 1/27/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import <Foundation/Foundation.h>

// This is a proxy class used for message forwarding to delegates AND/OR overriding classes (e.g. view controllers)
//
// All targetDelegate classes should extend SPADelegate and implement appropriate init methods that are aware of this
// proxy. The designated initializer is: - (id)initWithOverrider:(id)overrider
//
// Example:
//
// ...
// #import "SPADelegateProxy.h";
// ...
// @implementation SPATextDelegate
//
// + (id)delegateWithViewController:(UIViewController *)viewController
// {
//     return [self delegateWithOverrider:viewController];
// }
//
// - (id)initWithOverrider:(UIViewController *)viewController
// {
//     id proxy = [super initWithOverrider:viewController];
//     self = [proxy targetDelegate];
//     if (self) {
//         _scrollView = (UIScrollView *)viewController.view;
//         ...
//     }
//     return proxy;
// }
// ...
// @end
//
// Overriders are expected to "own" this object, although referred to as an instance of the targetDelegate.
// Instantiation should use the SPADelegate "delegateWithOverrider" class method (or an extended version)
//
// Example:
//
// @interface MyViewController()
// ...
// @property SPATextDelegate *textDelegate; // strong pointer
// ...
// @end
//
// @implementation MyViewController
// ...
// - (void)viewDidLoad
// {
//     [super viewDidLoad];
//     self.textDelegate = [SPATextDelegate delegateWithOverrider:self]; // init and retain
//     self.textField.delegate = self.textDelegate; // most UIView delegate properties use weak pointers
// }
// ...
// @end
//
// Method overriding:
//
// If the Overrider has a method, it will be used instead of targetDelegate's method... If the Overrider wants to extend
// the targetDelegate method, all it needs to do is call the method again from within its method (similar to the
// functionality of super).
//
// Example - in Overrider:
//
// - (void)textFieldDidBeginEditing:(UITextField *)textField
// {
//     [self.textDelegate textFieldDidBeginEditing:textField]; // this will execute the default functionality
//     [self doSomethingElse];
// }
//
@interface SPADelegateProxy : NSObject

@property id targetDelegate;

+ (id)delegateProxyWithOverrider:(id)overrider targetDelegate:(id)delegate;

@end
