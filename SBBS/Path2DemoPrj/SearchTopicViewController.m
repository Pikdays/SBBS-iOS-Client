//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SearchTopicViewController.h"

@implementation SearchTopicViewController
@synthesize searchString;
@synthesize topTenArray;
@synthesize mDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        topTenArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    //[self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-108)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 108) Delegate:self];
    [self.view addSubview:customTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    topTenArray = nil;
    customTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopTenTableViewCell"];
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
    cell.board = topic.board;
    cell.top = topic.top;
    cell.unread = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 80;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Topic * topic = [topTenArray objectAtIndex:indexPath.row];
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    
    [home restoreViewLocation];
    [home removeOldViewController];
    home.realViewController = singleTopicViewController;
    [home showViewController:topic.author];
}

-(void)firstTimeLoad
{    
    NSArray * topics = [BBSAPI searchTopics:searchString start:@"0" Token:myBBS.mySelf.token];
    [self.topTenArray removeAllObjects];
    [self.topTenArray addObjectsFromArray:topics];
    [customTableView reloadData];
    [activityView removeFromSuperview];
    activityView = nil;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
    [customTableView setAlpha:1];
	[UIView commitAnimations];
}

-(void)reloadData
{    
    [customTableView setAlpha:0];
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI searchTopics:searchString start:@"0" Token:myBBS.mySelf.token];
        [self.topTenArray removeAllObjects];
        [self.topTenArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)loadMoreTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI searchTopics:searchString start:[NSString stringWithFormat:@"%i",[topTenArray count]] Token:myBBS.mySelf.token];
        [self.topTenArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)refreshTableView
{
    [customTableView reloadData];
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}
- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(loadMoreTable) toTarget:self withObject:nil];
}
@end
