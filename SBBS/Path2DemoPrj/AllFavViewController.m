//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AllFavViewController.h"

@implementation AllFavViewController
@synthesize topTenArray;
@synthesize topTitleString;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)firstTimeLoad
{
    self.topTenArray = [BBSAPI allFavSections:myBBS.mySelf.token];
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
    self.title = topTitleString;
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;

    if (topTenArray == nil) {
        customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        [self.view addSubview:customTableView];
        
        [activityView start];
        [self.view addSubview:activityView];
        [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
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
        [self.view addSubview:normalTableView];
        [normalTableView reloadData];
    }
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
    
    customTableView = nil;
    normalTableView = nil;
}


#pragma mark - UITableView delegate
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
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.homeViewController.navigationController pushViewController:topicsViewController animated:YES];

    }
    else {
        AllFavViewController * allSectionsViewController = [[AllFavViewController alloc] init];
        allSectionsViewController.topTenArray= board.sectionBoards;
        allSectionsViewController.topTitleString = board.name;
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
	return cell;
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        self.topTenArray = [BBSAPI allFavSections:myBBS.mySelf.token];
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
