//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SearchUserViewController.h"
@implementation SearchUserViewController
@synthesize searchString;
@synthesize searchedUser;

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
    //[self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-108)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 108) Delegate:self];
    [self.view addSubview:customTableView];
    [customTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) dealloc
{
    customTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - UITableView delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchedUser == nil) {
        return 0;
    }
    return 1;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserInfoViewController * userInfoViewController;
    userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    userInfoViewController.userString = self.searchedUser.ID;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.leftnavController presentPopupViewController:userInfoViewController animationType:MJPopupViewAnimationSlideTopBottom];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCellView * cell = (FriendCellView *)[tableView dequeueReusableCellWithIdentifier:@"FriendCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"FriendCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    cell.user = searchedUser;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
}

-(void)firstTimeLoad
{
    self.searchedUser = [BBSAPI userInfo:searchString];
    if (self.searchedUser != nil) {
        [customTableView reloadData];
    }
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
        self.searchedUser = [BBSAPI userInfo:searchString];
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


@end
