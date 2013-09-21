//
//  KeyboardHandle.h
//  虎踞龙蟠
//
//  Created by Zhang Xiaobo on 3/2/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardHandle : NSObject

+(void)dismissKeyboard;
+(void)globalResignFirstResponder;
+(void)globalResignFirstResponderRec:(UIView*) view;

@end
