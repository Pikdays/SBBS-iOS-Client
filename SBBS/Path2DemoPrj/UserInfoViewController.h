//
//  UserInfoViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "CustomTableView.h"
#import "PostMailViewController.h"
#import "SingleTopicCell.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "UIImageView+WebCache.h"

@interface UserInfoViewController : UIViewController
{
    NSString * userString;
    User * user;
    MyBBS * myBBS;
    MBProgressHUD * HUD;
    FPActivityView* activityView;
    BOOL failed;
    
    IBOutlet UILabel * nameViewLabel;
    IBOutlet UIButton * sentMailButton;
    IBOutlet UIButton * addFriendButton;
    
    IBOutlet UILabel * ID; //用户ID
    IBOutlet UILabel * name; //用户中文昵称
    IBOutlet UILabel * lastlogin; //上次登录时间
    IBOutlet UILabel * level; //等级称谓
    IBOutlet UILabel * posts; //发文数
    IBOutlet UILabel * perform; //表现值
    IBOutlet UILabel * experience; //经验值
    IBOutlet UILabel * medals; //勋章数
    IBOutlet UILabel * logins; //上站次数
    IBOutlet UILabel * life; //生命值
    IBOutlet UILabel * gender; //性别，M为男性，F为女性（用户相关设置允许后显示）
    IBOutlet UILabel * astro; //星座（用户相关设置允许后显示)
    IBOutlet UIImageView * avatar;//用户头像
    IBOutlet UIView * avatarMask;
}

@property(nonatomic, strong)NSString * userString;
@property(nonatomic, strong)User * user;

-(IBAction)addFriend:(id)sender;
-(IBAction)back:(id)sender;
-(IBAction)sendMail:(id)sender;


@end
