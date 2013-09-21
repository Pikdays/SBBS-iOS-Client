//
//  NotificationViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomNoFooterTableView.h"
#import "TopTenTableViewCell.h"
#import "SingleTopicViewController.h"
#import "SingleMailViewController.h"
#import "MailsViewCell.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
@interface NotificationViewController : UIViewController<UIActionSheetDelegate>
{
    CustomNoFooterTableView * customTableView;
    MyBBS * myBBS;
    MBProgressHUD * HUD;
    
    NSArray * showNotificationArray;
    UISegmentedControl * seg;
    UIImageView * commentNotificationImageView;
    UIImageView * atNotificationImageView;
    UIImageView * mailNotificationImageView;
}
@property(nonatomic, strong)NSArray * showNotificationArray;
@property(nonatomic, strong)UISegmentedControl * seg;
@property(nonatomic, strong)UIImageView * commentNotificationImageView;
@property(nonatomic, strong)UIImageView * atNotificationImageView;
@property(nonatomic, strong)UIImageView * mailNotificationImageView;


-(IBAction)clearAll:(id)sender;
@end
