//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BBSAPI.h"
#import "MyBBS.h"
#import "SearchViewController.h"
#import "TopTenViewController.h"
#import "BoardsViewController.h"
#import "AllSectionsViewController.h"
#import "LoginViewController.h"
#import "AllFavViewController.h"
#import "FriendsViewController.h"
#import "MailBoxViewController.h"
#import "NotificationViewController.h"
#import "NotificationCell.h"
#import "HomeViewController.h"
#import "TopicsViewController.h"
#import "AboutViewController.h"

@interface LeftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIActionSheetDelegate, AboutViewControllerDelegate> {
    NSArray *tableTitles1;
    NSArray *tableTitles2;
    NSArray *tableTitles3;
    
    NSArray *tableIcon1;
    NSArray *tableIcon2;
    NSArray *tableIcon3;
    
    SearchViewController * searchViewController;
    IBOutlet UISearchBar * search;
    IBOutlet UITableView * mainTableView;
    UIButton *settingsButton;
    MyBBS * myBBS;
    BOOL isFirstTimeLoad;
    NSIndexPath *selectedIndex;
}
@property(nonatomic, strong)IBOutlet UITableView * mainTableView;
-(void)showNotification;
@end
