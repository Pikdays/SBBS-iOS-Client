//
//  SearchTopicViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TopTenTableViewCell.h"
#import "CustomTableView.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "SingleTopicViewController.h"
#import "HomeViewController.h"

@interface SearchTopicViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSString * searchString;
    NSMutableArray * topTenArray;
    CustomTableView * customTableView;
    FPActivityView* activityView;
    id mDelegate;
    MyBBS * myBBS;
}
@property(nonatomic, strong)NSString * searchString;
@property(nonatomic, strong)NSMutableArray * topTenArray;
@property(nonatomic, strong)id mDelegate;

-(void)reloadData;
@end
