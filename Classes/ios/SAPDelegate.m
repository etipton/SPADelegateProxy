//
//  SAPDelegate.m
//  Spectappular
//
//  Created by Eric Tipton on 1/28/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import "SAPDelegate.h"
#import "SAPDelegateProxy.h"

@implementation SAPDelegate

+ (id)delegateWithOverrider:(id)overrider
{
    return [[self alloc] initWithOverrider:overrider];
}

- (id)initWithOverrider:(id)overrider
{
    return [SAPDelegateProxy delegateProxyWithOverrider:overrider targetDelegate:[super init]];
}

@end
