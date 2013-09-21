//
//  MyBBS.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MyBBS.h"

@implementation MyBBS
@synthesize allSections;
@synthesize mySelf;
@synthesize notification;
@synthesize notificationCount;

- (id)init
{
    self = [super init];
    if (self) {
        notificationCount = 0;
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * username = [defaults stringForKey:@"UserName"];
        NSString * userid = [defaults stringForKey:@"UserID"];
        NSString * usertoken = [defaults stringForKey:@"UserToken"];
        NSString * userAvatar = [defaults stringForKey:@"UserAvatar"];
        
        if (username != NULL) {
            self.mySelf = [[User alloc] init];
            mySelf.name = username;
            mySelf.ID = userid;
            mySelf.token = usertoken;
        
            if (userAvatar != NULL) {
                mySelf.avatar = [NSURL URLWithString:userAvatar];
            }
        }
        
        NSData * allsectionsdata = [defaults dataForKey:@"AllSections"];
        if (allsectionsdata != NULL){
            self.allSections = [BBSAPI offlineDataToAllSections:allsectionsdata];
        }
    }
    return self;
}

-(void)refreshAllSections
{
    NSData * allsectionsdata = [BBSAPI allSectionsData:mySelf.token];
    self.allSections = [BBSAPI offlineDataToAllSections:allsectionsdata];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:allsectionsdata forKey:@"AllSections"];
}
-(User *)userLogin:(NSString *)user Pass:(NSString *)pass
{
    self.mySelf = [BBSAPI login:user Pass:pass];
    
    if (mySelf == nil) {
        return nil;
    }
    else {
        User *mySelfDetal = [BBSAPI userInfo:mySelf.ID];
        if (mySelfDetal) {
            self.mySelf.avatar = mySelfDetal.avatar;
        }
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL isGotDeviceToken = [defaults boolForKey:@"isGotDeviceToken"];
        if (isGotDeviceToken) {
            BOOL success = [BBSAPI addNotificationToken:mySelf.token iToken:[defaults objectForKey:@"DeviceToken"]];
            [defaults setBool:success forKey:@"isPostDeviceToken"];
            if (!success) {
                return nil;
            }
        }
        
        if (self.mySelf.avatar != nil) {
            [defaults setValue:[mySelf.avatar absoluteString] forKey:@"UserAvatar"];
        }
        [defaults setValue:mySelf.name forKey:@"UserName"];
        [defaults setValue:mySelf.ID forKey:@"UserID"];
        [defaults setValue:mySelf.token forKey:@"UserToken"];
        return mySelf;
    }   
}

-(BOOL)addPushNotificationToken
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL success = [BBSAPI addNotificationToken:mySelf.token iToken:[defaults objectForKey:@"DeviceToken"]];
    [defaults setBool:success forKey:@"isPostDeviceToken"];
    return success;
}

-(void)userLogout
{
    mySelf.name = nil;
    mySelf.ID = nil;
    mySelf.token = nil;
    mySelf.avatar = nil;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:NULL forKey:@"UserName"];
    [defaults setValue:NULL forKey:@"UserID"];
    [defaults setValue:NULL forKey:@"UserToken"];
    [defaults setValue:NULL forKey:@"UserAvatar"];
}

-(void)refreshNotification
{
    int oldNotificationCount = 0;
    if (notification != nil) {
        oldNotificationCount = notification.count;
    }
    self.notification = [BBSAPI getNotification:mySelf.token];
    if (notification != nil) {
        notificationCount = [notification.mails count] + [notification.ats count] + [notification.replies count];
        notification.count = notificationCount;
    }
}
-(void)clearNotification
{
    [BBSAPI clearNotification:mySelf.token];
}

@end
