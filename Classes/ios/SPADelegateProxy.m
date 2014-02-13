//
//  SPADelegateProxy.m
//  Spectappular
//
//  Created by Eric Tipton on 1/27/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import "SPADelegateProxy.h"

@interface SPADelegateProxy ()

@property (weak) id overrider;
// used for allowing VC to execute default functionality (see forwardInvocation method)
@property NSMutableSet *overriderInvocations; // (actually a set of NSStringFromSelector() strings)

- (id)initWithOverrider:(id)overrider targetDelegate:(id)delegate;

@end

@implementation SPADelegateProxy

+ (id)delegateProxyWithOverrider:(id)overrider targetDelegate:(id)delegate
{
    return [[self alloc] initWithOverrider:overrider targetDelegate:delegate];
}

- (id)initWithOverrider:(id)overrider targetDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _overrider = overrider;
        _targetDelegate = delegate;
        _overriderInvocations = NSMutableSet.new;
    }
    return self;
}

// If the Overrider has a method, it will be used instead of targetDelegate's method... If the Overrder wants to extend
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
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *selectorString = NSStringFromSelector(anInvocation.selector);
    if (![self.overriderInvocations containsObject:selectorString] &&
        [self.overrider respondsToSelector:anInvocation.selector]) {
            [self.overriderInvocations addObject:selectorString];
            [anInvocation invokeWithTarget:self.overrider];
            [self.overriderInvocations removeObject:selectorString];
    } else if ([self.targetDelegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.targetDelegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [self.overrider respondsToSelector:aSelector] ||
        [self.targetDelegate respondsToSelector:aSelector];
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return [self.targetDelegate isKindOfClass:aClass];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) signature = [self.overrider methodSignatureForSelector:selector];
    if (!signature) signature = [self.targetDelegate methodSignatureForSelector:selector];

    return signature;
}

@end
