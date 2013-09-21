//
//  SingleTopicViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "TopicsViewController.h"
#import "CustomTableView.h"
#import "SingleTopicCell.h"
#import "SingleTopicCommentCell.h"
#import "PostTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "UserInfoViewController.h"
#import "WebViewController.h"
#import "UIViewController+MJPopupViewController.h"

@protocol SingleTopicViewControllerDelegate <NSObject>
-(void)refreshNotification;
@end

@interface SingleTopicViewController : UIViewController<MBProgressHUDDelegate, UIActionSheetDelegate, SingleTopicCellDelegate, SingleTopicCommentCellDelegate>
{
    Topic *rootTopic;
    Topic *selectTopic;
    NSMutableArray *topicsArray;

    CustomTableView *customTableView;
    
    FPActivityView* activityView;
    MyBBS * myBBS;
    
    BOOL isForShowNotification;
    id __unsafe_unretained mDelegate;
    TopTenTableViewCell * selectedCell;
    
    int tableHeight;
}
@property(nonatomic, strong)Topic * rootTopic;
@property(nonatomic, assign)BOOL isForShowNotification;
@property(nonatomic, unsafe_unretained)id mDelegate;
@property(nonatomic, strong)CustomTableView * customTableView;
@property(nonatomic, strong)TopTenTableViewCell * selectedCell;
@property(nonatomic, strong)UIViewController *forRetainController;

- (id)initWithRootTopic:(Topic *)topic;
- (IBAction)back:(id)sender;

@end
