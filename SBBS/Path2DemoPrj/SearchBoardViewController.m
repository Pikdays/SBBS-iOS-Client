//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SearchBoardViewController.h"
@implementation SearchBoardViewController
@synthesize searchString;

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
    //[self.view setFrame:CGRectMake(0, 108, rect.size.width, rect.size.height - 108)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 108) Delegate:self];
    [self.view addSubview:customTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)dealloc
{
    topTenArray = nil;
    customTableView = nil;
    activityView = nil;
}

#pragma mark - UITableView delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topTenArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TopicsViewController * topicsViewController = [[TopicsViewController alloc] init];
    Board * b = [topTenArray objectAtIndex:indexPath.row];
    topicsViewController.boardName = b.name;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home restoreViewLocation];
    [home removeOldViewController];
    home.realViewController = topicsViewController;
    [home showViewController:b.name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardsCellView * cell = (BoardsCellView *)[tableView dequeueReusableCellWithIdentifier:@"BoardsCellView"];
    if (cell == nil) {
        cell = [[BoardsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoardsCellView"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Board * b = [topTenArray objectAtIndex:indexPath.row];
    cell.name = b.name;
    cell.description = b.description;
    cell.section = b.section;
    cell.leaf = b.leaf;
    
    if (!b.leaf) {
        //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
}

-(void)firstTimeLoad
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    NSArray * topics = [BBSAPI searchBoards:searchString Token:myBBS.mySelf.token];
    [topTenArray removeAllObjects];
    [topTenArray addObjectsFromArray:topics];
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
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
}


#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSArray * topics =  [BBSAPI searchBoards:searchString Token:myBBS.mySelf.token];
        [topTenArray removeAllObjects];
        [topTenArray addObjectsFromArray:topics];
        
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
