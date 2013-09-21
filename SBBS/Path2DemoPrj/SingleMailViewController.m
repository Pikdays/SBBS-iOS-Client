//
//  SingleMailViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/6/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleMailViewController.h"

@implementation SingleMailViewController
@synthesize rootMail;
@synthesize mail;
@synthesize isForShowNotification;
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isForShowNotification = NO;
    }
    return self;
}

-(void)firstTimeLoad
{
    self.mail = [BBSAPI getSingleMail:myBBS.mySelf.token Type:rootMail.type ID:rootMail.ID];
    
    if (mail.type == 0)
        [authorLabel setText:[NSString stringWithFormat:@"%@", mail.author]];
    if (mail.type == 1)
        [authorLabel setText:[NSString stringWithFormat:@"%@", mail.author]];
    if (mail.type == 2)
        [authorLabel setText:[NSString stringWithFormat:@"%@", mail.author]];
    [titleLabel setText:mail.title];
    [content setText:mail.content];
    [timeLabel setText:[BBSAPI dateToString:mail.time]];
    
    [scrollView addSubview:realView];
    
    UIFont *font = [UIFont systemFontOfSize:17.0];
    CGSize size = [mail.content sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width - 30, 10000) lineBreakMode:NSLineBreakByWordWrapping];

    [content setFrame:CGRectMake(content.frame.origin.x, content.frame.origin.y, self.view.frame.size.width - 30, size.height)];

    [realView setFrame:CGRectMake(0, 0, self.view.frame.size.width, content.frame.origin.y + size.height)];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, content.frame.origin.y + size.height+10)];
    if (content.frame.origin.y + size.height+10 <= self.view.frame.size.height) {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 10)];
    }
    [activityView removeFromSuperview];
    activityView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 64)];

    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        [realScrollView setFrame:CGRectMake(0, 64, rect.size.width, rect.size.height - 64)];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    }
    else
    {
        [realScrollView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 64)];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }
    
    UIBarButtonItem *replyButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(reply:)];
    self.navigationItem.rightBarButtonItem = replyButton;
    
    if (rootMail.type == 0)
        [topTitle setText:@"收件箱"];
    if (rootMail.type == 1)
        [topTitle setText:@"发件箱"];
    if (rootMail.type == 2)
        [topTitle setText:@"废件箱"];

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;

    
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
    
    [self attachLongPressHandler];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [super dealloc];
    [rootMail release];
    rootMail = nil;
    [mail release];
    mail = nil;
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (isForShowNotification) {
        [mDelegate refreshNotification];
    }
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


-(IBAction)reply:(id)sender
{
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] init];
    postMailViewController.postType = 1;
    postMailViewController.rootMail = rootMail;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailViewController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
    [postMailViewController release];
}

#pragma -Longpress

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyTitleLabel:) || action == @selector(copyContentLabel:) || action == @selector(copyAuthorLabel:) ) {
        return YES;
    }
    return NO;
}

//针对于copy的实现
-(void)copyTitleLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = titleLabel.text;
}
-(void)copyContentLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = content.text;
}
-(void)copyAuthorLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = authorLabel.text;
}

//添加touch事件
-(void)attachLongPressHandler{
    self.view.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *copyTitle = [[UIMenuItem alloc] initWithTitle:@"复制标题" action:@selector(copyTitleLabel:)];
        UIMenuItem *copyContent = [[UIMenuItem alloc] initWithTitle:@"复制正文" action:@selector(copyContentLabel:)];
        UIMenuItem *copyAuthor = [[UIMenuItem alloc] initWithTitle:@"复制发信人" action:@selector(copyAuthorLabel:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copyAuthor, copyTitle, copyContent, nil]];
        [menu setTargetRect:self.view.frame inView:self.view];
        [menu setMenuVisible:YES animated:YES];
    }
}

@end
