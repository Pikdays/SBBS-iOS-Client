//
//  PushNotificationWindow.m
//  虎踞龙蟠
//
//  Created by Zhang Xiaobo on 3/1/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import "PushNotificationWindow.h"
#import "NotificationTopicViewController.h"
#import "NotificationWebViewController.h"
#import "KeyboardHandle.h"

@implementation PushNotificationWindow
@synthesize isBBSNews;
@synthesize newsURL;
@synthesize boardID;
@synthesize topicID;
@synthesize mDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
    }
    return self;
}

- (void)setReadyToShow
{
    [KeyboardHandle dismissKeyboard];
    
    if (isBBSNews) {
        Topic * topic = [[Topic alloc] init];
        topic.board = boardID;
        topic.ID = [topicID intValue];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        NotificationTopicViewController * notificationTopicViewController = [[NotificationTopicViewController alloc] initWithNibName:@"NotificationTopicViewController" bundle:nil];
        notificationTopicViewController.rootTopic = topic;
        notificationTopicViewController.mDelegate = self;
        [notificationTopicViewController.view setFrame:CGRectMake(0, 20, rect.size.width, rect.size.height - 20)];
        self.rootViewController = notificationTopicViewController;
    }
    else
    {
        CGRect rect = [[UIScreen mainScreen] bounds];
        NotificationWebViewController * notificationWebViewController = [[NotificationWebViewController alloc] initWithNibName:@"NotificationWebViewController" bundle:nil];
        notificationWebViewController.newsurl = newsURL;
        notificationWebViewController.mDelegate = self;
        [notificationWebViewController.view setFrame:CGRectMake(0, 20, rect.size.width, rect.size.height - 20)];
        self.rootViewController = notificationWebViewController;
    }
}

-(void)dismissNotification
{
    [mDelegate dismissNotification];
}
@end
