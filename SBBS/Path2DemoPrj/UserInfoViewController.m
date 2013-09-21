//
//  UserInfoViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "UserInfoViewController.h"

@implementation UserInfoViewController
@synthesize userString;
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)refreshView
{
    [ID setText:user.ID];
    [name setText:[NSString stringWithFormat:@"%@", user.name]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString * lastloginstring = [dateFormatter stringFromDate:user.lastlogin];
    [lastlogin setText:[NSString stringWithFormat:@"%@",lastloginstring]];
    
    [level setText:[NSString stringWithFormat:@"%@", user.level]];
    [posts setText:[NSString stringWithFormat:@"%i", user.posts]];
    [perform setText:[NSString stringWithFormat:@"%i", user.perform]];
    [experience setText:[NSString stringWithFormat:@"%i", user.experience]];
    [medals setText:[NSString stringWithFormat:@"%i", user.medals]];
    [logins setText:[NSString stringWithFormat:@"%i", user.logins]];
    [life setText:[NSString stringWithFormat:@"%i", user.life]];
    
    if (user.gender != NULL) {
        if([user.gender isEqualToString:@"M"])
            [gender setText:[NSString stringWithFormat:@"%@", @"帅哥"]];
        else
            [gender setText:[NSString stringWithFormat:@"%@", @"美女"]];
        
        [astro setText:[NSString stringWithFormat:@"%@", user.astro]];
    }
    else {
        [gender setText:@"保密"];
        [astro setText:@"保密"];
    }
}

-(void)firstTimeLoad
{
    if (myBBS.mySelf.ID != nil && [myBBS.mySelf.ID isEqualToString:userString]) {
        
    }
    else if (myBBS.mySelf.ID != nil && [BBSAPI isFriend:myBBS.mySelf.token ID:userString]){
        [sentMailButton setHidden:NO];
    }
    else if (myBBS.mySelf.ID != nil && ![myBBS.mySelf.ID isEqualToString:userString]){
        [sentMailButton setHidden:NO];
        [addFriendButton setHidden:NO];
    }
    
    self.user = [BBSAPI userInfo:userString];
    [activityView removeFromSuperview];
    activityView = nil;
    
    [avatar setImage:nil];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
    if (isLoadAvatar && self.user.avatar != nil) {
        [avatar setImageWithURL:user.avatar];
    }
    else {
        NSString * viewString = [self.user.ID length] >= 5 ? [[self.user.ID substringToIndex:5] uppercaseString]: [self.user.ID uppercaseString];
        nameViewLabel.text = viewString;
    }
    
    [self refreshView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [addFriendButton setHidden:YES];
    [sentMailButton setHidden:YES];
    
    //CGRect rect = [[UIScreen mainScreen] bounds];
    //[self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.layer.cornerRadius = 7.0f;
    self.view.clipsToBounds = YES;
    avatar.layer.cornerRadius = 6.0f;
    avatar.clipsToBounds = YES;
    avatarMask.layer.cornerRadius = 6.0f;
    avatarMask.clipsToBounds = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

-(void)dealloc
{
    ID = nil;
    name = nil;
    lastlogin = nil;
    level = nil;
    posts = nil;
    perform = nil;
    experience = nil;
    medals = nil;
    logins = nil;
    life = nil;
    gender = nil;
    astro = nil;
    avatar = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    ID = nil;
    name = nil;
    lastlogin = nil;
    level = nil;
    posts = nil;
    perform = nil;
    experience = nil;
    medals = nil;
    logins = nil;
    life = nil;
    gender = nil;
    astro = nil;
    avatar = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)back:(id)sender
{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)addFriend:(id)sender
{
    BOOL success = [BBSAPI addFriend:myBBS.mySelf.token ID:user.ID];
    if (success) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"添加好友成功";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
        [addFriendButton setHidden:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"添加好友失败";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
        [addFriendButton setHidden:YES];
    }
}

-(IBAction)sendMail:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] init];
    postMailViewController.postType = 2;
    postMailViewController.sentToUser = user.ID;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailViewController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [appDelegate.homeViewController presentViewController:nav animated:YES completion:nil];
}

@end
