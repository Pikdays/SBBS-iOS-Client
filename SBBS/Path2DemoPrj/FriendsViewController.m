//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "FriendsViewController.h"

@implementation FriendsViewController
@synthesize allFriendsArray;
@synthesize onlineFriendsArray;

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
    self.title = @"好友";
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 108) Delegate:self];
    [self.view addSubview:customTableView];
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
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
    customTableView = nil;
    showArray = nil;
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

#pragma mark - UITableView delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [showArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User * user = [showArray objectAtIndex:indexPath.row];
    
    UserInfoViewController * userInfoViewController;
    userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    userInfoViewController.userString = user.ID;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.homeViewController presentPopupViewController:userInfoViewController animationType:MJPopupViewAnimationSlideTopBottom];
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


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            return UITableViewCellEditingStyleNone;
            break;
        case 1:
            return UITableViewCellEditingStyleDelete;
            break;
        default:
            break;
    }
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    User * user = [showArray objectAtIndex:indexPath.row];
    BOOL deletFriend = [BBSAPI deletFriend:myBBS.mySelf.token ID:user.ID];
    if (deletFriend) {
        
        NSMutableArray * newallFriendsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [allFriendsArray count]; i++) {
            if (i != indexPath.row) {
                [newallFriendsArray addObject:[allFriendsArray objectAtIndex:i]];
            }
        }
        allFriendsArray = newallFriendsArray;
        showArray = allFriendsArray;
        [customTableView.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else {

    }
}



#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        self.onlineFriendsArray = [BBSAPI onlineFriends:myBBS.mySelf.token];
        self.allFriendsArray = [BBSAPI allFriends:myBBS.mySelf.token];
        switch (seg.selectedSegmentIndex) {
            case 0:
                showArray = onlineFriendsArray;
                break;
            case 1:
                showArray = allFriendsArray;
                break;
            default:
                break;
        }
        
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
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
