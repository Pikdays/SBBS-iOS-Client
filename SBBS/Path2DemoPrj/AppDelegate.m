//
//  AppDelegate.m
//  Path2DemoPrj
//
//  Created by Ethan on 11-12-14.
//  Copyright (c) 2011年 Ethan. All rights reserved.
//  
//  个人承接iOS项目, QQ:44633450 / email: gaoyijun@gmail.com
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PushNotificationWindow.h"
#import "AFNetworkActivityIndicatorManager.h"

NSUInteger DeviceSystemMajorVersion (){
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
                                       componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize leftnavController = _leftnavController;

@synthesize leftViewController;
@synthesize homeViewController;

@synthesize myBBS;
@synthesize isSearching;

@synthesize notificationWindow;
@synthesize selectedUserInfo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.myBBS = [[MyBBS alloc] init];
    
    //CGRect rect = [[UIScreen mainScreen] bounds];
    
    // main view (nav)
    [self.navController.view layer].shadowPath = [UIBezierPath bezierPathWithRect:[self.navController.view layer].bounds].CGPath;
    self.navController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navController.view.layer.shadowOpacity = 0.6f;
    self.navController.view.layer.shadowOffset = CGSizeMake(-1.0, 0.8f);
    self.navController.view.layer.shadowRadius = 2.0f;
    self.navController.view.layer.masksToBounds = NO;
    
    self.window.rootViewController = self.leftnavController;
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
    /*
    self.window.rootViewController = self.leftnavController;
    [self.window.rootViewController.view addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tapReceivedNotificationHandler:)
                                                 name:kMPNotificationViewTapReceivedNotification
                                               object:nil];
    
    
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    /*
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            if ([[[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"bbsnews"]) {
                NSString * boardID = [[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"board"];
                NSString * topicID = [[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"postId"];
                
                if (self.notificationWindow != nil) {
                    [notificationWindow.rootViewController.view removeFromSuperview];
                }
                self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
                notificationWindow.isBBSNews = YES;
                notificationWindow.mDelegate = self;
                notificationWindow.boardID = boardID;
                notificationWindow.topicID = topicID;
                [notificationWindow setReadyToShow];
                [self showNotificationWithDelay:1.2];
            }
            if ([[[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"urlnews"]) {
                NSString * url = [[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"url"];
                
                if (self.notificationWindow != nil) {
                    [notificationWindow.rootViewController.view removeFromSuperview];
                }
                self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
                notificationWindow.isBBSNews = NO;
                notificationWindow.mDelegate = self;
                notificationWindow.newsURL = url;
                [notificationWindow setReadyToShow];
                [self showNotificationWithDelay:1.2];
            }
        }
    }
    */
    return YES;
}

- (void)showLeftViewTotaly{
    [self.homeViewController moveToRightSideTotaly];
}
- (void)showLeftView{
    [self.homeViewController moveToRightSide];
}
-(void)showHomeView{
    [self.homeViewController restoreViewLocation];
}

-(void)refreshTable
{
    @autoreleasepool {
        [self.myBBS refreshNotification];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)refreshTableView
{
    [self.leftViewController.mainTableView reloadData];
}


- (void)refreshNotification
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}

-(void)applicationWillResignActive:(UIApplication *)application {
/*
 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
 */
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [self refreshNotification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */

    if (self.myBBS.notificationCount == 0) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.myBBS.notificationCount];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

/*
#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
*/

#pragma mark - MPNotificationViewDelegate
- (void)didTapOnNotificationView:(MPNotificationView *)notificationView
{
    //[self.homeViewController leftBarBtnTapped:nil];
}

- (void)tapReceivedNotificationHandler:(NSNotification *)notice
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (selectedUserInfo) {
        if ([[[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"bbsnews"]) {
            NSString * boardID = [[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"board"];
            NSString * topicID = [[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"postId"];
            
            if (self.notificationWindow != nil) {
                [notificationWindow.rootViewController.view removeFromSuperview];
            }
            self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
            notificationWindow.isBBSNews = YES;
            notificationWindow.mDelegate = self;
            notificationWindow.boardID = boardID;
            notificationWindow.topicID = topicID;
            [notificationWindow setReadyToShow];
            [self showNotificationWithDelay:0.2];
        }
        if ([[[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"urlnews"]) {
            NSString * url = [[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"url"];
            
            if (self.notificationWindow != nil) {
                [notificationWindow.rootViewController.view removeFromSuperview];
            }
            self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
            notificationWindow.isBBSNews = NO;
            notificationWindow.mDelegate = self;
            notificationWindow.newsURL = url;
            [notificationWindow setReadyToShow];
            [self showNotificationWithDelay:0.2];
        }
    }
}

//推送通知处理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //4c772442 8d9f795e 429df5dc 149c653b 6e127f29 09a728e0 28f226b8 b6fdf747
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL isGotDeviceToken = [defaults boolForKey:@"isGotDeviceToken"];
    BOOL isPostDeviceToken = [defaults boolForKey:@"isPostDeviceToken"];
    if (!isGotDeviceToken || !isPostDeviceToken) {
        NSMutableString * rawtoken = [NSMutableString stringWithFormat:@"%@",deviceToken];
        NSString * token = [rawtoken substringWithRange:NSMakeRange(1, 71)];
        NSLog(@"Device token:%@",token);
        NSString *encodedcontent = [token URLEncodedString];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedcontent forKey:@"DeviceToken"];
        [defaults setBool:YES forKey:@"isGotDeviceToken"];
        
        if (myBBS.mySelf != nil) {
            [myBBS addPushNotificationToken];
        }
    }
    else {
        return;
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*
    if (application.applicationState == UIApplicationStateActive) {
        self.selectedUserInfo = userInfo;
        if ([[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"bbsnews"] || [[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"urlnews"]){
            
            CFURLRef		soundFileURLRef;
            SystemSoundID	soundFileObject;
            NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"myNotification"
                                                        withExtension: @"m4a"];
            soundFileURLRef = (__bridge CFURLRef) tapSound;
            AudioServicesCreateSystemSoundID (soundFileURLRef, &soundFileObject);
            AudioServicesPlaySystemSound (soundFileObject);
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            
            [MPNotificationView notifyWithText:@"新推送内容，点击查看"
                                        detail:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
                                         image:[UIImage imageNamed:@"icon.png"]
                                   andDuration:3.0];
        }
        else{
            [self refreshNotification];
            
            CFURLRef		soundFileURLRef;
            SystemSoundID	soundFileObject;
            NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"myNotification"
                                                        withExtension: @"m4a"];
            soundFileURLRef = (__bridge CFURLRef) tapSound;
            AudioServicesCreateSystemSoundID (soundFileURLRef, &soundFileObject);
            AudioServicesPlaySystemSound (soundFileObject);
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            
            [MPNotificationView notifyWithText:@"新消息，请到消息中心查看"
                                        detail:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
                                         image:[UIImage imageNamed:@"icon.png"]
                                   andDuration:3.0];
        }
        return;
    }
    
    //从后台进入
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (userInfo) {
        if ([[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"bbsnews"]) {
            NSString * boardID = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"board"];
            NSString * topicID = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"postId"];
            
            if (self.notificationWindow != nil) {
                [notificationWindow.rootViewController.view removeFromSuperview];
            }
            self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
            notificationWindow.isBBSNews = YES;
            notificationWindow.mDelegate = self;
            notificationWindow.boardID = boardID;
            notificationWindow.topicID = topicID;
            [notificationWindow setReadyToShow];
            [self showNotificationWithDelay:0.2];
        }
        if ([[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"urlnews"]) {
            NSString * url = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"url"];
            
            if (self.notificationWindow != nil) {
                [notificationWindow.rootViewController.view removeFromSuperview];
            }
            self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
            notificationWindow.isBBSNews = NO;
            notificationWindow.mDelegate = self;
            notificationWindow.newsURL = url;
            [notificationWindow setReadyToShow];
            [self showNotificationWithDelay:0.2];
        }
    }
     */
}

-(void)showNotificationWithDelay:(float)delay
{
    /*
    [notificationWindow.rootViewController.view setFrame:CGRectMake(0, 600, 320, notificationWindow.rootViewController.view.frame.size.height)];
    [self.window addSubview:notificationWindow.rootViewController.view];
    [UIView animateWithDuration:0.5f delay:delay options:UIViewAnimationOptionBeginFromCurrentState  animations:^{
        [notificationWindow.rootViewController.view setFrame:CGRectMake(0, 20, 320, notificationWindow.rootViewController.view.frame.size.height)];
    } completion:^(BOOL finished) {
    }];
     */
}
-(void)dismissNotification
{
    /*
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState  animations:^{
        [notificationWindow.rootViewController.view setFrame:CGRectMake(0, 600, 320, notificationWindow.rootViewController.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [notificationWindow.rootViewController.view removeFromSuperview];
    }];
     */
}

@end
