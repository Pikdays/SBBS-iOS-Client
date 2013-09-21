//
//  SingleTopicViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "NotificationWebViewController.h"

@implementation NotificationWebViewController
@synthesize newsurl;
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    [webView setFrame:CGRectMake(0, 64, rect.size.width, rect.size.height-64)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newsurl]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [webView stopLoading];
    webView = nil;
}

-(IBAction)back:(id)sender
{
    [mDelegate dismissNotification];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)showActionSheet:(id)sender
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                 initWithTitle:@"更多操作"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"复制链接", @"用Safari打开" ,nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = newsurl;
    }
    if(buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newsurl]];
    }
}
@end
