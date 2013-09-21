//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AllSectionsViewController.h"

@implementation AllSectionsViewController
@synthesize topTenArray;
@synthesize topTitleString;
@synthesize isMenu;
@synthesize isForSectionTopTen;


- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)firstTimeLoad
{
    if ([topTitleString isEqualToString:@"分类讨论区"]) {
        [myBBS refreshAllSections];
        self.topTenArray = myBBS.allSections;
    }

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
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.title = topTitleString;
    
    /*
    if (![topTitleString isEqualToString:@"分类讨论区"] && !isMenu) {
        UIBarButtonItem * addFavButton = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(addFavDirect:)];
        UIBarButtonItem * addFavButton2 = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)]];
        NSArray * array = [NSArray arrayWithObjects:addFavButton2, addFavButton, nil];
        self.navigationItem.rightBarButtonItems = array;
    }
    */
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    if ([myBBS.allSections count] == 0) {
        customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        
        [self.view addSubview:customTableView];
        [activityView start];
        [self.view addSubview:activityView];
        [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
    }
    else {
        if ([topTitleString isEqualToString:@"分类讨论区"]) {
            customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
            [self.view addSubview:customTableView];
            self.topTenArray = myBBS.allSections;
            [customTableView reloadData];
        }
        else {
            if (IS_IOS7) {
                normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
            }
            else {
                normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
            }
            normalTableView.dataSource = self;
            normalTableView.delegate = self;
            normalTableView.directionalLockEnabled = YES;
            normalTableView.decelerationRate = 0;
            [normalTableView setClipsToBounds:NO];
            [self.view addSubview:normalTableView];
            [normalTableView reloadData];
        }
    }
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

-(IBAction)back:(id)sender
{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)dealloc
{
    customTableView = nil;
    normalTableView = nil;
}

#pragma mark - UITableView delegate
//指定有多少个分区(Section)，默认为1
/*
 -(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
 {
 return 1;
 }
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topTenArray count];
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Board * board = [topTenArray objectAtIndex:indexPath.row]; 
    
    if (board.leaf) {
        TopicsViewController * topicsViewController = [[TopicsViewController alloc] init];
        Board * b = [topTenArray objectAtIndex:indexPath.row];
        topicsViewController.boardName = b.name;
        [self.navigationController pushViewController:topicsViewController animated:YES];
    }
    else {
        AllSectionsViewController * allSectionsViewController = [[AllSectionsViewController alloc] init];
        allSectionsViewController.topTenArray= board.sectionBoards;
        allSectionsViewController.topTitleString = board.name;
        if ([topTitleString isEqualToString:@"分类讨论区"])
        {
            allSectionsViewController.isMenu = TRUE;
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.homeViewController.navigationController pushViewController:allSectionsViewController animated:YES];
    }
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
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    if (isForSectionTopTen) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
	return cell;
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        [myBBS refreshAllSections];
        self.topTenArray = myBBS.allSections;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
}

-(IBAction)addFavDirect:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.myBBS.mySelf.ID == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
    else if([BBSAPI addFavBoard:appDelegate.myBBS.mySelf.token BoardName:topTitleString]){
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
