//
//  PostTopicViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "PostMailViewController.h"

@implementation PostMailViewController
@synthesize rootMail;
@synthesize sentToUser;
@synthesize postType;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *sendButton =[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = sendButton;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
        postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    }
    postScrollView.contentSize = CGSizeMake(rect.size.width, self.view.frame.size.height - 64 + 1);
    postScrollView.delegate = self;
    
    UILabel * userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 21)];
    userLabel.textColor = [UIColor whiteColor];
    userLabel.backgroundColor = [UIColor lightGrayColor];
    userLabel.font = [UIFont systemFontOfSize:15];
    userLabel.textAlignment = NSTextAlignmentCenter;
    userLabel.text = @"发给";
    postUser = [[UITextField alloc] initWithFrame:CGRectMake(60, 5, 205, 21)];
    postUser.textColor = [UIColor lightGrayColor];
    postUser.placeholder = @"添加收件人";
    [postUser addTarget:self action:@selector(inputTitle:) forControlEvents:UIControlEventEditingChanged];
    addUserButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addUserButton setFrame:CGRectMake(285, 5, 21, 21)];
    [addUserButton addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];
    [postScrollView addSubview:userLabel];
    [postScrollView addSubview:postUser];
    [postScrollView addSubview:addUserButton];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 40, 21)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标题";
    postTitle = [[UITextField alloc] initWithFrame:CGRectMake(60, 30, 205, 21)];
    postTitle.textColor = [UIColor lightGrayColor];
    postTitle.placeholder = @"添加标题";
    [postTitle addTarget:self action:@selector(inputTitle:) forControlEvents:UIControlEventEditingChanged];
    postTitleCount = [[UILabel alloc] initWithFrame:CGRectMake(280, 30, 30, 21)];
    postTitleCount.textColor = [UIColor lightGrayColor];
    postTitleCount.textAlignment = NSTextAlignmentRight;
    postContent = [[UITextView alloc] initWithFrame:CGRectMake(5, 55, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 55)];
    [postContent setFont:[UIFont systemFontOfSize:17]];
    [postScrollView addSubview:titleLabel];
    [postScrollView addSubview:postTitle];
    [postScrollView addSubview:postTitleCount];
    [postScrollView addSubview:postContent];
    [self.view addSubview:postScrollView];
    
    if (postType == 0) {
        self.title = @"发新邮件";
        [postUser setText:@""];
        [postUser becomeFirstResponder];
        [sendButton setEnabled:NO];
        [postTitle setText:@""];
        [postContent setText:@""];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [sendButton setEnabled:NO];
    }
    if (postType == 1) {
        self.title = @"回复邮件";
        [postUser setText:rootMail.author];
        [postUser setEnabled:NO];
        [addUserButton setHidden:YES];
        
        if ([rootMail.title length] >=4 && [[rootMail.title substringToIndex:4] isEqualToString:@"Re: "]) {
            [postTitle setText:[NSString stringWithFormat:@"%@", rootMail.title]];
        }
        else {
            [postTitle setText:[NSString stringWithFormat:@"Re: %@", rootMail.title]];
        }
        
        [postContent setText:@""];
        [postContent becomeFirstResponder];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
    }
    if (postType == 2) {
        self.title = @"发新邮件";
        [postUser setText:sentToUser];
        [postUser setEnabled:NO];
        [addUserButton setHidden:YES];
        [postTitle becomeFirstResponder];
        [postTitle setText:@""];
        [postContent setText:@""];
        [postTitle becomeFirstResponder];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [sendButton setEnabled:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    UIPanGestureRecognizer* recognizer;
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWillBeginDragging:)];
    [self.view addGestureRecognizer:recognizer];
}

-(IBAction)inputTitle:(id)sender
{
    [postTitleCount setText:[NSString stringWithFormat:@"%i",[postTitle.text length]]];
    int count = [postUser.text length];
    if (count == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send
{
    [postUser resignFirstResponder];
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.labelText = @"发送中...";
	[HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
}


-(void)firstTimeLoad
{
    [HUD removeFromSuperview];
    if([self didPost])
    {
        [self performSelectorOnMainThread:@selector(sendSuccess) withObject:nil waitUntilDone:NO];
    }
    else {
        [self performSelectorOnMainThread:@selector(sendFailed) withObject:nil waitUntilDone:NO];
    }
}

-(void)sendSuccess
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendFailed
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"发送失败";
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
}

-(BOOL)didPost
{
    if (postType == 0) {
        return [BBSAPI postMail:myBBS.mySelf.token User:postUser.text Title:postTitle.text Content:postContent.text Reid:0];
    }
    if (postType == 1) {
        return [BBSAPI postMail:myBBS.mySelf.token User:postUser.text Title:postTitle.text Content:postContent.text Reid:rootMail.ID];
    }
    if (postType == 2) {
        return [BBSAPI postMail:myBBS.mySelf.token User:postUser.text Title:postTitle.text Content:postContent.text Reid:0];
    }
    return 0;
}


-(IBAction)addUser:(id)sender
{
    AddPostUserViewController * addPostUserViewController = [[AddPostUserViewController alloc] init];
    addPostUserViewController.mDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addPostUserViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)didAddUser:(NSString *)userID
{
    [postUser setText:userID];
    [postTitle becomeFirstResponder];
}

-(void)dismissAddUserView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [postUser resignFirstResponder];
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    
    [postScrollView setContentOffset:CGPointMake(0, 0)];
    [postContent setFrame:CGRectMake(5, 55, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 55 - keyboardRect.size.height - 2)];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (postContent.contentSize.height < self.view.frame.size.height - 64 - 55) {
        [postContent setFrame:CGRectMake(5, 55, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 55)];
    }
    else
    {
        [postContent setFrame:CGRectMake(5, 55, self.view.frame.size.width - 10, postContent.contentSize.height)];
        [postScrollView setContentSize:CGSizeMake(postScrollView.contentSize.width, postContent.contentSize.height + 55)];
    }
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
