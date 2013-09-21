//
//  SearchViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBoardViewController.h"
#import "SearchTopicViewController.h"
#import "SearchUserViewController.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@interface SearchViewController : UIViewController
{
    NSString * searchString;
    
    SearchBoardViewController * searchBoardViewController;
    SearchTopicViewController * searchTopicViewController;
    SearchUserViewController * searchUserViewController;
    
    UISegmentedControl * seg;
}
@property(nonatomic, strong)SearchBoardViewController * searchBoardViewController;
@property(nonatomic, strong)SearchTopicViewController * searchTopicViewController;
@property(nonatomic, strong)SearchUserViewController * searchUserViewController;
@property(nonatomic, strong)NSString * searchString;
@property(nonatomic, strong)UISegmentedControl * seg;

-(void)refreshSearching;
@end
