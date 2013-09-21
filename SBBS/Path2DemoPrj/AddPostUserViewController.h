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

@protocol AddPostUserViewControllerDelegate <NSObject>

-(void)dismissAddUserView;
-(void)didAddUser:(NSString *)userID;

@end

@interface AddPostUserViewController : UIViewController<MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray * onlineFriendsArray;
    NSArray * allFriendsArray;
    NSArray * showArray;
    
    IBOutlet UIButton * editFriendButton;
    UISegmentedControl * seg;
    CustomNoFooterWithDeleteTableView * customTableView;
    FPActivityView* activityView;
    id mDelegate;
    
    MyBBS * myBBS;
}
@property(nonatomic, retain)NSArray * onlineFriendsArray;
@property(nonatomic, retain)NSArray * allFriendsArray;
@property(nonatomic, assign)id mDelegate;

-(void)cancel;
-(IBAction)segmentControlValueChanged:(id)sender;
@end
