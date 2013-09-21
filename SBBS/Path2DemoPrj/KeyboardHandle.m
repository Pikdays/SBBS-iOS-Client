//
//  KeyboardHandle.m
//  虎踞龙蟠
//
//  Created by Zhang Xiaobo on 3/2/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import "KeyboardHandle.h"

@implementation KeyboardHandle

+ (void)dismissKeyboard {
    [self globalResignFirstResponder];
}

+ (void) globalResignFirstResponder {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    for (UIView * view in [window subviews]){
        [self globalResignFirstResponderRec:view];
    }
}

+ (void) globalResignFirstResponderRec:(UIView*) view {
    if ([view respondsToSelector:@selector(resignFirstResponder)]){
        [view resignFirstResponder];
    }
    for (UIView * subview in [view subviews]){
        [self globalResignFirstResponderRec:subview];
    }
}

@end
