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


@interface BoardsViewController : UIViewController<MBProgressHUDDelegate>
{
    NSArray * topTenArray;
    CustomNoFooterTableView * customTableView;
    FPActivityView* activityView;
}
@property(nonatomic, strong)NSArray * topTenArray;

-(IBAction)back:(id)sender;
@end
