//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopicsViewController.h"

@implementation TopicsViewController
@synthesize boardName;
@synthesize topTenArray;
@synthesize customTableView;
@synthesize readModeSeg;

- (id)init
{
    self = [super init];
    if (self) {
        topTenArray = [[NSMutableArray alloc] init];
        readModeSegIsShowing = FALSE;
    }
    return self;
}

-(void)firstTimeLoad
{
    curMode = 2;
    modeContent=[[NSArray alloc] initWithObjects:@"全部帖子",@"主题帖",@"论坛模式",@"置顶帖",@"文摘区",@"保留区", nil];
    NSArray * topics = [BBSAPI boardTopics:boardName Start:0 Token:myBBS.mySelf.token Mode:curMode];
    [topTenArray addObjectsFromArray:topics];
    
    [customTableView reloadData];
    [activityView removeFromSuperview];
    activityView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = boardName;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    self.navigationItem.title = boardName;
    UIBarButtonItem *composeButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(postNewTopic)];
    //UIBarButtonItem *addFavButton=[[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(addFavBoard)];
    UIBarButtonItem *changeButton=[[UIBarButtonItem alloc] initWithTitle:@"模式" style:UIBarButtonItemStylePlain target:self action:@selector(changeReadMode)];
    
    NSArray * array = [NSArray arrayWithObjects:composeButton, changeButton, nil];
    self.navigationItem.rightBarButtonItems = array;
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    if (IS_IOS7 && self.navigationController != nil) {
        self.customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    }
    else {
        self.customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }
    
    [self.view addSubview:customTableView];

    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];

    NSArray * itemArray = [NSArray arrayWithObjects:@"全部", @"主题", @"论坛", @"置顶", @"文摘", @"保留", nil];
    readModeSegToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -44, self.view.frame.size.width, 44)];
    self.readModeSeg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [readModeSeg setSelectedSegmentIndex:2];
    [readModeSeg setFrame:CGRectMake(6, 7, self.view.frame.size.width - 10, 30)];
    [readModeSeg addTarget:self action:@selector(readModeSegChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (!IS_IOS7) {
        [readModeSeg setSegmentedControlStyle:UISegmentedControlStyleBar];
        [readModeSeg setTintColor:[UIColor lightGrayColor]];
        [readModeSegToolBar setTintColor:[UIColor lightGrayColor]];
    }
    
    [readModeSegToolBar addSubview:readModeSeg];
    [self.view addSubview:readModeSegToolBar];
    
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    
}

#pragma mark - 
#pragma mark tableViewDelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topTenArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identi = @"TopTenTableViewCell";
    TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Topic * topic = [topTenArray objectAtIndex:indexPath.row];
    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.time = topic.time;
    cell.author = topic.author;
    cell.replies = topic.replies;
    cell.read = topic.read;
    //cell.board = topic.board;
    cell.board = nil;
    cell.top = topic.top;
    if (curMode != 2) {
        cell.unread = YES;
    }
    else {
        cell.unread = topic.unread;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 80;
}

-(void)clearCellBack:(UITableViewCell *)cell
{
    cell.backgroundColor = [UIColor clearColor];
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightTextColor];
    [self performSelector:@selector(clearCellBack:) withObject:cell afterDelay:0.5];
    
    Topic * topic = [topTenArray objectAtIndex:indexPath.row];
    topic.unread = FALSE;
    
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:[topTenArray objectAtIndex:indexPath.row]];
    singleTopicViewController.mDelegate = self;
    if (curMode == 2) {
        singleTopicViewController.selectedCell = (TopTenTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI boardTopics:boardName Start:0 Token:myBBS.mySelf.token Mode:curMode];
        [topTenArray removeAllObjects];
        [topTenArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)refreshTableView
{
    [activityView removeFromSuperview];
    activityView = nil;
    [customTableView reloadData];
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}

-(void)loadMoreTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI boardTopics:boardName Start:[topTenArray count] Token:myBBS.mySelf.token Mode:curMode];
        [topTenArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(loadMoreTable) toTarget:self withObject:nil];
}

- (void)postNewTopic
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.myBBS.mySelf.ID == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
    else {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
        postTopicViewController.postType = 0;
        postTopicViewController.boardName = boardName;
        postTopicViewController.mDelegate = appDelegate.homeViewController;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [appDelegate.homeViewController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)addFavBoard
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([BBSAPI addFavBoard:appDelegate.myBBS.mySelf.token BoardName:boardName]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"收藏版面成功";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"收藏版面失败";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
    }
}

-(IBAction)readModeSegChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    curMode = myUISegmentedControl.selectedSegmentIndex;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [readModeSegToolBar setFrame:CGRectMake(0, -44, self.view.frame.size.width, 44)];
    [UIView commitAnimations];
    readModeSegIsShowing = FALSE;
    
    if (IS_IOS7) {
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    }
    else {
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(refreshTable) withObject:nil];
    
    [customTableView.mTableView setContentOffset:CGPointMake(0, 0)];
}


-(void)changeReadMode
{
    if (readModeSegIsShowing) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        [readModeSegToolBar setFrame:CGRectMake(0, -44, self.view.frame.size.width, 44)];
        [UIView commitAnimations];
        readModeSegIsShowing = FALSE;
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        if (IS_IOS7) {
            [readModeSegToolBar setFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
        }
        else {
            [readModeSegToolBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        }
        [UIView commitAnimations];
        readModeSegIsShowing = TRUE;
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

@end
