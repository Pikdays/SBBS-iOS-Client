//
//  PushNotificationWindow.h
//  虎踞龙蟠
//
//  Created by Zhang Xiaobo on 3/1/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PushNotificationWindowDelegate <NSObject>
-(void)dismissNotification;
@end


@interface PushNotificationWindow : UIWindow
{
    BOOL isBBSNews;
    
    NSString * newsURL;
    
    NSString * boardID;
    NSString * topicID;
    id __unsafe_unretained mDelegate;
}
@property(nonatomic, assign)BOOL isBBSNews;
@property(nonatomic, retain)NSString * newsURL;
@property(nonatomic, retain)NSString * boardID;
@property(nonatomic, retain)NSString * topicID;
@property(nonatomic, unsafe_unretained)id mDelegate;
- (void)setReadyToShow;
@end
