//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AddPostUserViewController.h"

@implementation AddPostUserViewController
@synthesize onlineFriendsArray;
@synthesize allFriendsArray;
@synthesize mDelegate;

- (id)initWithRootTopic:(Topic *)topic
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)firstTimeLoad
{
    self.onlineFriendsArray = [BBSAPI onlineFriends:myBBS.mySelf.token];
    self.allFriendsArray = [BBSAPI allFriends:myBBS.mySelf.token];
    showArray = onlineFriendsArray;
    [customTableView reloadData];
    
    [activityView removeFromSuperview];
    activityView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.title = @"添加用户";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    UIToolbar * toolbar;
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height - 108) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, 1)];
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    }
    else {
        [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
        customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 108) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    }
    [self.view addSubview:customTableView];
    
    NSArray * itemArray = [NSArray arrayWithObjects:@"在线好友", @"全部好友", nil];
    seg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [seg setSelectedSegmentIndex:0];
    [seg setFrame:CGRectMake(6, 7, self.view.frame.size.width - 10, 30)];
    [seg addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (!IS_IOS7) {
        [seg setSegmentedControlStyle:UISegmentedControlStyleBar];
        [seg setTintColor:[UIColor lightGrayColor]];
        [toolbar setTintColor:[UIColor lightGrayColor]];
    }
    
    [toolbar addSubview:seg];
    [self.view addSubview:toolbar];
    
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
}

-(void)cancel
{
    [mDelegate dismissAddUserView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [super dealloc];
    [allFriendsArray release];
    allFriendsArray = nil;
    [onlineFriendsArray release];
    onlineFriendsArray = nil;
    [customTableView release];
    customTableView = nil;
    showArray = nil;
}

#pragma mark - UITableView delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [showArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
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
    
    User * user = [showArray objectAtIndex:indexPath.row];
    [mDelegate didAddUser:user.ID];
    [mDelegate dismissAddUserView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCellView * cell = (FriendCellView *)[tableView dequeueReusableCellWithIdentifier:@"FriendCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"FriendCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    cell.user = [showArray objectAtIndex:indexPath.row];
	return cell;
}





#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.onlineFriendsArray = [BBSAPI onlineFriends:myBBS.mySelf.token];
    self.allFriendsArray = [BBSAPI allFriends:myBBS.mySelf.token];
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    [pool release];
}
-(void)refreshTableView
{
    [customTableView reloadData];
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    switch (myUISegmentedControl.selectedSegmentIndex) {
        case 0:
            showArray = onlineFriendsArray;
            break;
        case 1:
            showArray = allFriendsArray;
            break;
        default:
            break;
    }
    [customTableView reloadData];
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
