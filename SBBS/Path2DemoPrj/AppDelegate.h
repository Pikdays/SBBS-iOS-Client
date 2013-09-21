//
//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//
\

#import <UIKit/UIKit.h>
#import "MyBBS.h"
#import "MPNotificationView.h"

#define IS_IOS7 (DeviceSystemMajorVersion() >= 7)
NSUInteger DeviceSystemMajorVersion ();


@class LeftViewController;
@class HomeViewController;
@class PushNotificationWindow;

@interface AppDelegate : UIResponder <UIApplicationDelegate, MPNotificationViewDelegate, UIAlertViewDelegate> {
    MyBBS * myBBS;
    BOOL isSearching;

    PushNotificationWindow * notificationWindow;
    NSDictionary * selectedUserInfo;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationController *leftnavController;
@property (strong, nonatomic) IBOutlet HomeViewController *homeViewController;
@property (strong, nonatomic) IBOutlet LeftViewController *leftViewController;
@property (strong, nonatomic) MyBBS * myBBS;
@property (nonatomic, assign)BOOL isSearching;
@property (strong, nonatomic) PushNotificationWindow * notificationWindow;
@property (strong, nonatomic) NSDictionary * selectedUserInfo;

- (void)showLeftViewTotaly;
- (void)showLeftView;
-(void)refreshNotification;
-(void)refreshTableView;
@end

