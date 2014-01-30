//
//  SPATextDelegate.h
//  Spectappular
//
//  Created by Eric Tipton on 1/21/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPADelegate.h"

// conforms to UITextFieldDelegate and UITextViewDelegate protocols
// and therefore has standard ways of responding to keyboard notifications

// NOTE: the viewController's view property must be a ScrollView
@interface SPATextDelegate : SPADelegate <UITextFieldDelegate, UITextViewDelegate>

+ (id)delegateWithViewController:(UIViewController *)viewController;

@end
