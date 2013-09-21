//
//  NotificationTopicViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SingleTopicCommentCell.h"
#import "PostTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "UserInfoViewController.h"

@protocol NotificationWebViewControllerDelegate <NSObject>
-(void)dismissNotification;
@end


@interface NotificationWebViewController : UIViewController<UIActionSheetDelegate>
{
    IBOutlet UIWebView * webView;
    NSString * newsurl;
    id __unsafe_unretained mDelegate;
}
@property(nonatomic, strong)NSString * newsurl;
@property(nonatomic, unsafe_unretained)id mDelegate;

-(IBAction)back:(id)sender;
-(IBAction)showActionSheet:(id)sender;
@end
