//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "CustomTableView.h"
#import "TopTenTableViewCell.h"
#import "SingleTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@interface TopicsViewController : UIViewController<MBProgressHUDDelegate>
{
    NSString * boardName;
    NSMutableArray * topTenArray;
    CustomTableView * customTableView;
    NSArray *modeContent;
    UIPickerView *modePicker;
    IBOutlet UILabel * topTitle;
    UISegmentedControl * readModeSeg;
    UIToolbar * readModeSegToolBar;
    BOOL readModeSegIsShowing;
    FPActivityView* activityView;
    int curMode;// 0 全部帖子（默认） 1 主题贴 2 论坛模式 3 置顶帖 4 文摘区 5 保留区
    MyBBS * myBBS;
}
@property(nonatomic, retain)NSString * boardName;
@property(nonatomic, strong)NSArray * topTenArray;
@property(nonatomic, strong)CustomTableView * customTableView;
@property(nonatomic, strong)UISegmentedControl * readModeSeg;

-(void)changeReadMode;
-(IBAction)readModeSegChanged:(id)sender;
@end
