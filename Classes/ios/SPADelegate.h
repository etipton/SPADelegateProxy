//
//  SPADelegate.h
//  Spectappular
//
//  Created by Eric Tipton on 1/28/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPADelegate : NSObject

+ (id)delegateWithOverrider:(id)overrider;
- (id)initWithOverrider:(id)overrider;

@end
