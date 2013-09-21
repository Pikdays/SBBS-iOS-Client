//
//  NotificationViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "NotificationViewController.h"
@implementation NotificationViewController
@synthesize showNotificationArray;
@synthesize seg;
@synthesize commentNotificationImageView;
@synthesize atNotificationImageView;
@synthesize mailNotificationImageView;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    NSArray * itemArray = [NSArray arrayWithObjects:@"回复", @"@我", @"邮件", nil];
    self.seg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [seg setSelectedSegmentIndex:0];
    [seg setFrame:CGRectMake(6, 7, self.view.frame.size.width - 10, 30)];
    [seg addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [toolbar addSubview:seg];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.commentNotificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 17, 10, 10)];
        self.atNotificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(188, 17, 10, 10)];
        self.mailNotificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 17, 10, 10)];
    }
    else {
        self.commentNotificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 17, 10, 10)];
        self.atNotificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(470, 17, 10, 10)];
        self.mailNotificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(730, 17, 10, 10)];
    }
    
    
    
    [commentNotificationImageView setBackgroundColor:[UIColor redColor]];
    [atNotificationImageView setBackgroundColor:[UIColor redColor]];
    [mailNotificationImageView setBackgroundColor:[UIColor redColor]];
    
    commentNotificationImageView.layer.cornerRadius = 5.0f;
    commentNotificationImageView.clipsToBounds = YES;
    atNotificationImageView.layer.cornerRadius = 5.0f;
    atNotificationImageView.clipsToBounds = YES;
    mailNotificationImageView.layer.cornerRadius = 5.0f;
    mailNotificationImageView.clipsToBounds = YES;
    
    
    if (!IS_IOS7) {
        [seg setSegmentedControlStyle:UISegmentedControlStyleBar];
        [seg setTintColor:[UIColor lightGrayColor]];
        [toolbar setTintColor:[UIColor lightGrayColor]];
    }
    
    [toolbar addSubview:commentNotificationImageView];
    [toolbar addSubview:atNotificationImageView];
    [toolbar addSubview:mailNotificationImageView];
    [self.view addSubview:toolbar];
    
    UIBarButtonItem *clearButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearAll:)];
    //UIBarButtonItem *clearButton=[[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll:)];
    appDelegate.homeViewController.navigationItem.rightBarButtonItem = clearButton;
    
    myBBS = appDelegate.myBBS;
    customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 108) Delegate:self];
    [self.view insertSubview:customTableView atIndex:0];
    [self refreshTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)dealloc
{
    customTableView = nil;
}

#pragma mark - 
#pragma mark tableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.showNotificationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (seg.selectedSegmentIndex == 2) {
        MailsViewCell * cell = (MailsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MailsViewCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MailsViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        Mail * mail = [myBBS.notification.mails objectAtIndex:indexPath.row];
        cell.mail = mail;
        return cell;
    }
    
    if (seg.selectedSegmentIndex == 1) {
        TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopTenTableViewCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        Topic * topic = [myBBS.notification.ats objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.title = topic.title;
        cell.author = topic.author;
        cell.board = topic.board;
        cell.unread = YES;
        return cell;
    }
    
    if (seg.selectedSegmentIndex == 0) {
        TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopTenTableViewCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        Topic * topic = [myBBS.notification.replies objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.title = topic.title;
        cell.author = topic.author;
        cell.board = topic.board;
        cell.unread = YES;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    if (seg.selectedSegmentIndex == 2) {
        return 66;
    }
    return 80;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (seg.selectedSegmentIndex == 2) {
        SingleMailViewController * singleMailViewController = [[SingleMailViewController alloc] initWithNibName:@"SingleMailViewController" bundle:nil];
        singleMailViewController.rootMail = [myBBS.notification.mails objectAtIndex:indexPath.row];
        singleMailViewController.isForShowNotification = YES;
        singleMailViewController.mDelegate = self;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:singleMailViewController animated:YES];
    }
    if (seg.selectedSegmentIndex == 1) {
        SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:[myBBS.notification.ats objectAtIndex:indexPath.row]];
        singleTopicViewController.isForShowNotification = YES;
        singleTopicViewController.mDelegate = self;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:singleTopicViewController animated:YES];
    }
    if (seg.selectedSegmentIndex == 0) {
        SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:[myBBS.notification.replies objectAtIndex:indexPath.row]];
        singleTopicViewController.isForShowNotification = YES;
        singleTopicViewController.mDelegate = self;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:singleTopicViewController animated:YES];
    }
}
-(void)showActionSheet
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc] 
                                 initWithTitle:@"确定删除所有消息？"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
    
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self doclear];
    }
}

-(IBAction)clearAll:(id)sender
{
    if (myBBS.notification.count > 0) {
        [self showActionSheet];
    }
}

-(void)clearNotification
{
    [myBBS clearNotification];
    [myBBS refreshNotification];
    [self refreshTable];
    [HUD removeFromSuperview];
    HUD = nil;
}
- (void)doclear
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:1];
	HUD.labelText = @"清除消息中...";
    [HUD showWhileExecuting:@selector(clearNotification) onTarget:self withObject:nil animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate refreshNotification];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}

-(void)refreshTableView
{
    if (seg.selectedSegmentIndex == 0) {
        self.showNotificationArray = myBBS.notification.replies;
    }
    if (seg.selectedSegmentIndex == 1) {
        self.showNotificationArray = myBBS.notification.ats;
    }
    if (seg.selectedSegmentIndex == 2) {
        self.showNotificationArray = myBBS.notification.mails;
    }
    [self refreshNotificationImageView];
    [customTableView reloadData];
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}

#pragma -
#pragma mark RefreshNotification delegate
-(void)refreshNotification
{
    [self refreshTable];
}

-(void)refreshNotificationImageView
{
    if ([myBBS.notification.replies count] == 0)
        [commentNotificationImageView setHidden:YES];
    else
        [commentNotificationImageView setHidden:NO];
    
    if ([myBBS.notification.ats count] == 0)
        [atNotificationImageView setHidden:YES];
    else
        [atNotificationImageView setHidden:NO];
    
    if ([myBBS.notification.mails count] == 0)
        [mailNotificationImageView setHidden:YES];
    else
        [mailNotificationImageView setHidden:NO];
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    [self refreshTableView];
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
