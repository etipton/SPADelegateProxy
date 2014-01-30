//
//  SPADelegate.m
//  Spectappular
//
//  Created by Eric Tipton on 1/28/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import "SPADelegate.h"
#import "SPADelegateProxy.h"

@implementation SPADelegate

+ (id)delegateWithOverrider:(id)overrider
{
    return [[self alloc] initWithOverrider:overrider];
}

- (id)initWithOverrider:(id)overrider
{
    return [SPADelegateProxy delegateProxyWithOverrider:overrider targetDelegate:[super init]];
}

@end
