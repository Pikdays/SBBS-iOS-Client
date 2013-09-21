//
//  BoardsViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CustomNoFooterTableView.h"
#import "BoardsCellView.h"
#import "TopicsViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"


@interface AllSectionsViewController : UIViewController<MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray * topTenArray;
    CustomNoFooterTableView * customTableView;
    UITableView * normalTableView;
    FPActivityView* activityView;
    NSString * topTitleString;
    MyBBS * myBBS;
    BOOL isMenu;
    BOOL isForSectionTopTen;
}
@property(nonatomic, strong)NSArray * topTenArray;
@property(nonatomic, strong)NSString * topTitleString;
@property(nonatomic, assign)BOOL isMenu;
@property(nonatomic, assign)BOOL isForSectionTopTen;

-(IBAction)addFavDirect:(id)sender;
@end
