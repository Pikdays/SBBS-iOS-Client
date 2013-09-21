//
//  NotificationViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomTableWithDeleteView.h"
#import "PostMailViewController.h"
#import "SingleMailViewController.h"
#import "MailsViewCell.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@interface MailBoxViewController : UIViewController
{
    CustomTableWithDeleteView * customTableView;
    MyBBS * myBBS;
    FPActivityView* activityView;
    
    NSMutableArray * mailsArray;
    UISegmentedControl * seg;
}
@property(nonatomic, strong)NSMutableArray * mailsArray;
@property(nonatomic, strong)UISegmentedControl * seg;

-(IBAction)newMail:(id)sender;
@end
