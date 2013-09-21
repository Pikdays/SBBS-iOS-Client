//
//  PostTopicViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BBSAPI.h"
#import "UploadAttachmentsViewController.h"
#import "HomeViewController.h"

@interface PostTopicViewController : UIViewController<UITextFieldDelegate, UIViewPassValueDelegate, UIScrollViewDelegate>
{
    UITextField * postTitle;
    UILabel * postTitleCount;
    UITextView * postContent;
    UIScrollView * postScrollView;
    
    MBProgressHUD * HUD;
    Topic * rootTopic;
    NSString * boardName;
    
    int postType; // 发表类型，0发表新文章，1回帖，2修改文章
    MyBBS * myBBS;
    id __unsafe_unretained mDelegate;
    
    NSArray *attList;
    
    UIToolbar *keyboardToolbar;
}
@property(nonatomic, strong)Topic * rootTopic;
@property(nonatomic, strong)NSString * boardName;
@property(nonatomic, assign)int postType;
@property(nonatomic, unsafe_unretained)id mDelegate;
@property(nonatomic, strong)NSArray * attList;
-(void)cancel;
-(void)send;
-(IBAction)operateAtt:(id)sender;
-(void)inputTitle;
-(void)inputContent;

@end
