//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "LeftViewController.h"

@implementation LeftViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.title = @"虎踞龙蟠";
    self.navigationItem.titleView = search;
    [self addSettingsButton];
    isFirstTimeLoad = YES;
    
    search.delegate = self;
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.886 green:0.886 blue:0.886 alpha:1]];
    }
    else {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.886 green:0.886 blue:0.886 alpha:1]];
        [search setTintColor:[UIColor colorWithRed:0.886 green:0.886 blue:0.886 alpha:1]];
    }
    
    searchViewController = [[SearchViewController alloc] init];
    [searchViewController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, rect.size.height)];
    [searchViewController.view setAlpha:0];
    [self.view addSubview:searchViewController.view];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    tableTitles1 = [NSArray arrayWithObjects:@"热门帖子", @"人气版面", @"分类讨论区",nil];
    if(myBBS.mySelf.ID != nil){
        tableTitles2 = [NSArray arrayWithObjects:@"收藏", @"好友", @"站内信", @"新消息", nil];
        tableTitles3 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",myBBS.mySelf.ID], nil];
    }
    else{
        tableTitles2 = [NSArray arrayWithObjects:@"登录",nil];
        tableTitles3 = [NSArray arrayWithObjects:@"未登录", nil];
    }
    
    tableIcon1 = [NSArray arrayWithObjects:@"top10.png", @"hot.png", @"more.png",nil];
    tableIcon2 = [NSArray arrayWithObjects:@"star.png", @"friend.png", @"letter.png", @"message.png", nil];
    //tableIcon3 = [NSArray arrayWithObjects:@"热门帖子", @"人气版面", @"分类讨论区",nil];
    
    [super viewDidLoad];
}


- (void) addSettingsButton
{
    settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 25, 25)];
    [settingsButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(clickSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* tools = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 185, 45)];
    [tools addSubview:settingsButton];
    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = myBtn;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    tableTitles1 = nil;
    tableTitles2 = nil;
    tableTitles3 = nil;
    searchViewController = nil;
    search = nil;
    myBBS = nil;
}

-(void)clickSettings
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         settingsButton.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
                     }
                     completion:^(BOOL finished){
                         AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         [appdelegate showLeftViewTotaly];
                         
                         AboutViewController * aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                         aboutViewController.mDelegate = self;
                         UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
                         nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                         [self presentViewController:nc animated:YES completion:nil];
                     }];
}

#pragma mark - UITableView delegate
// Section Titles
//每个section显示的标题
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    if(section == 0) {
        myView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        //myView.backgroundColor = [UIColor darkGrayColor];
        
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 3, 24, 24)];
        [headImageView setBackgroundColor:[UIColor clearColor]];
        [headImageView setImage:[UIImage imageNamed:@"frofile1.png"]];
        [myView addSubview:headImageView];
        headImageView.layer.cornerRadius = 12.0f;
        headImageView.clipsToBounds = YES;

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 0, 110, 30)];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"虎踞龙蟠";
        [myView addSubview:titleLabel];
    }
    if(section == 1)
    {
        myView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        //myView.backgroundColor = [UIColor darkGrayColor];
        
        if (myBBS.mySelf.avatar != nil) {
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 3, 24, 24)];
            [headImageView setBackgroundColor:[UIColor clearColor]];
            [headImageView setImageWithURL:myBBS.mySelf.avatar];
            [myView addSubview:headImageView];
            headImageView.layer.cornerRadius = 12.0f;
            headImageView.clipsToBounds = YES;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 0, 110, 30)];
            titleLabel.font = [UIFont boldSystemFontOfSize:15];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = [tableTitles3 objectAtIndex:0];
            [myView addSubview:titleLabel];
        }
        else {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 170, 30)];
            titleLabel.font = [UIFont boldSystemFontOfSize:15];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = [tableTitles3 objectAtIndex:0];
            [myView addSubview:titleLabel];
        }
    }
    return myView;
}


//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [tableTitles1 count];
    }
    if (section == 1) {
        return [tableTitles2 count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 3)
    {
        NotificationCell * cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
        if (cell == nil) {
            cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationCell"];
            cell.backgroundColor = [UIColor colorWithRed:0.886 green:0.886 blue:0.886 alpha:1];
            
            UIView *bgViewIndication = [[UIView alloc] init];
            [bgViewIndication setFrame:CGRectMake(0, 0, 5, 44)];
            bgViewIndication.backgroundColor = [UIColor colorWithRed:0.07 green:0.51 blue:1 alpha:1];
            
            
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = [UIColor clearColor];
            [bgView addSubview:bgViewIndication];
            
            cell.selectedBackgroundView = bgView;
            
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [cell.textLabel setHighlightedTextColor:[UIColor blackColor]];
            [cell.imageView setImage:[UIImage imageNamed:[tableIcon2 objectAtIndex:indexPath.row]]];
        }
        cell.notification = myBBS.notification;
        [cell refreshCell];
        return cell;
    }
    
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    cell.backgroundColor = [UIColor colorWithRed:0.886 green:0.886 blue:0.886 alpha:1];
    
    UIView *bgViewIndication = [[UIView alloc] init];
    [bgViewIndication setFrame:CGRectMake(0, 0, 5, 44)];
    bgViewIndication.backgroundColor = [UIColor colorWithRed:0.07 green:0.51 blue:1 alpha:1];

    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:bgViewIndication];
    
    cell.selectedBackgroundView = bgView;
    //[cell.selectedBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [cell.textLabel setHighlightedTextColor:[UIColor blackColor]];
    
    if(isFirstTimeLoad){
        // 默认选中第一行
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [tableTitles1 objectAtIndex:indexPath.row];
        [cell.imageView setImage:[UIImage imageNamed:[tableIcon1 objectAtIndex:indexPath.row]]];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [tableTitles2 objectAtIndex:indexPath.row];
        [cell.imageView setImage:[UIImage imageNamed:[tableIcon2 objectAtIndex:indexPath.row]]];
    }
	return cell;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    isFirstTimeLoad = NO;
    selectedIndex = indexPath;
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        TopTenViewController * topicsViewController = [[TopTenViewController alloc] init];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([appDelegate.homeViewController.title isEqualToString:@"热门帖子"]) {
            [appDelegate.homeViewController restoreViewLocation];
        }
        else {
            [appDelegate.homeViewController restoreViewLocation];
            [appDelegate.homeViewController removeOldViewController];
            appDelegate.homeViewController.realViewController = topicsViewController;
            [appDelegate.homeViewController showViewController:@"热门帖子"];
        }
    }
    if (indexPath.row == 1 && indexPath.section == 0) {
        BoardsViewController * boardsViewController = [[BoardsViewController alloc] init];
 
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([appDelegate.homeViewController.title isEqualToString:@"人气版面"]) {
            [appDelegate.homeViewController restoreViewLocation];
        }
        else {
            [appDelegate.homeViewController restoreViewLocation];
            [appDelegate.homeViewController removeOldViewController];
            appDelegate.homeViewController.realViewController = boardsViewController;
            [appDelegate.homeViewController showViewController:@"人气版面"];
        }
        
    }
    if (indexPath.row == 2 && indexPath.section == 0) {
        AllSectionsViewController * allSectionsViewController = [[AllSectionsViewController alloc] init];
        allSectionsViewController.topTitleString = @"分类讨论区";
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([appDelegate.homeViewController.title isEqualToString:@"分类讨论区"]) {
            [appDelegate.homeViewController restoreViewLocation];
        }
        else {
            [appDelegate.homeViewController restoreViewLocation];
            [appDelegate.homeViewController removeOldViewController];
            appDelegate.homeViewController.realViewController = allSectionsViewController;
            [appDelegate.homeViewController showViewController:@"分类讨论区"];
        }
    }
    
    if (myBBS.mySelf.ID == nil) {
        if (indexPath.row == 0 && indexPath.section == 1) {
            LoginViewController * loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginViewController.mDelegate = self;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate showLeftViewTotaly];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
    }
    if (myBBS.mySelf.ID != nil) {
        if (indexPath.row == 0 && indexPath.section == 1) {
            
            AllFavViewController *allFavViewController = [[AllFavViewController alloc] init];
            allFavViewController.topTitleString = @"收藏";
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([appDelegate.homeViewController.title isEqualToString:@"收藏"]) {
                [appDelegate.homeViewController restoreViewLocation];
            }
            else {
                [appDelegate.homeViewController restoreViewLocation];
                [appDelegate.homeViewController removeOldViewController];
                appDelegate.homeViewController.realViewController = allFavViewController;
                [appDelegate.homeViewController showViewController:@"收藏"];
            }
        }
        if (indexPath.row == 1 && indexPath.section == 1) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            FriendsViewController * friendsViewController = [[FriendsViewController alloc] init];
            
            if([appDelegate.homeViewController.title isEqualToString:@"好友"]) {
                [appDelegate.homeViewController restoreViewLocation];
            }
            else {
                [appDelegate.homeViewController restoreViewLocation];
                [appDelegate.homeViewController removeOldViewController];
                appDelegate.homeViewController.realViewController = friendsViewController;
                [appDelegate.homeViewController showViewController:@"好友"];
            }
        }
        if (indexPath.row == 2 && indexPath.section == 1) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            MailBoxViewController * mailBoxViewController = [[MailBoxViewController alloc] init];
            
            if([appDelegate.homeViewController.title isEqualToString:@"站内信"]) {
                [appDelegate.homeViewController restoreViewLocation];
            }
            else {
                [appDelegate.homeViewController restoreViewLocation];
                [appDelegate.homeViewController removeOldViewController];
                appDelegate.homeViewController.realViewController = mailBoxViewController;
                [appDelegate.homeViewController showViewController:@"站内信"];
            }
        }
        if (indexPath.row == 3 && indexPath.section == 1) {
            [self showNotification];
        }
    }
}

#pragma mark - UIsearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.isSearching = YES;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
    [mainTableView setAlpha:0];
    [searchViewController.view setAlpha:0];
	[UIView commitAnimations];
    [appdelegate showLeftViewTotaly];
    
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(searchBarCancelButtonClicked:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
    [searchViewController.view setAlpha:1];
	[UIView commitAnimations];
    
    //点击搜索时的响应事件
    searchViewController.searchString = sBar.text;
    [searchViewController refreshSearching];
    [search resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [search setText:@""];
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.isSearching = NO;
    
    //点击取消响应事件
    [searchViewController.view setAlpha:0];
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
    [mainTableView setAlpha:1];
	[UIView commitAnimations];
    
    [self addSettingsButton];
    [search resignFirstResponder];
    [appdelegate showLeftView];
}

#pragma mark - LoginViewDelegate
-(void)LoginSuccess
{
    NSArray * new = [NSArray arrayWithObjects:@"收藏",@"好友",@"站内信", @"新消息", nil];
    if (tableTitles2 != new) {
        tableTitles2 = new;
    }
    
    NSArray * new2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",myBBS.mySelf.ID], nil];
    if (tableTitles3 != new2) {
        tableTitles3 = new2;
    }
    
    [mainTableView reloadData];
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

#pragma mark - AboutViewDelegate
-(void)dismissAboutView
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.3
                     animations:^{
                         settingsButton.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         [appdelegate showLeftView];
                     }];
}

-(void)logout{
    [myBBS userLogout];
    NSArray * new = [NSArray arrayWithObjects:@"登录",nil];
    if (tableTitles2 != new) {
        tableTitles2 = new;
    }
    NSArray * new2 = [NSArray arrayWithObjects:@"未登录", nil];
    if (tableTitles3 != new2) {
        tableTitles3 = new2;
    }
    
    [mainTableView reloadData];
}

-(void)showNotification
{
    NotificationViewController * notificationViewController = [[NotificationViewController alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home restoreViewLocation];
    [home removeOldViewController];
    home.realViewController = notificationViewController;
    [home showViewController:@"新消息"];
}
@end
