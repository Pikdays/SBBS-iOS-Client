//
//  AllFavViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CustomNoFooterWithDeleteTableView.h"
#import "BoardsCellView.h"
#import "TopicsViewController.h"
#import "FriendCellView.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"


@interface FriendsViewController : UIViewController<MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray * onlineFriendsArray;
    NSArray * allFriendsArray;
    NSArray * showArray;
    
    UISegmentedControl * seg;
    CustomNoFooterWithDeleteTableView * customTableView;
    FPActivityView* activityView;
    
    id mDelegate;
    MyBBS * myBBS;
}
@property(nonatomic, strong)NSArray * onlineFriendsArray;
@property(nonatomic, strong)NSArray * allFriendsArray;

-(IBAction)back:(id)sender;
-(IBAction)segmentControlValueChanged:(id)sender;
@end
