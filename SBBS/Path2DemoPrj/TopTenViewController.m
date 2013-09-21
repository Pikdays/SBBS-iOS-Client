//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopTenViewController.h"

@implementation TopTenViewController
@synthesize topTenArray;
@synthesize customTableView;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)firstTimeLoad
{
    NSMutableArray * allArray = [[NSMutableArray alloc] init];
    NSArray *array;
    array = [BBSAPI topTen];
    if (array != nil) {
        [allArray addObject:[BBSAPI topTen]];
    }
    
    for (int i = 0; i < 12; i++) {
        array = [BBSAPI sectionTopTen:i];
        if (array != nil) {
            [allArray addObject:array];
        }
    }
    self.topTenArray = allArray;
    [customTableView reloadData];
    
    [activityView removeFromSuperview];
    activityView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 64)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"热门帖子";

    customTableView = [[CustomNoFooterViewSectionHeaderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) Delegate:self];
    [self.view addSubview:customTableView];
    
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - 
#pragma mark tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    UIView* myViewDropLine = [[UIView alloc] initWithFrame:CGRectMake(0, 22.5, self.view.frame.size.width, 0.5)];
    myViewDropLine.backgroundColor = [UIColor whiteColor];
    [myView addSubview:myViewDropLine];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 22)];
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"今日十大", @"本站系统 十大", @"东南大学 十大", @"电脑技术 十大", @"学术科学 十大", @"艺术文化 十大", @"乡情校谊 十大", @"休闲娱乐 十大", @"知性感性 十大", @"人文信息 十大", @"体坛风暴 十大", @"校务信箱 十大", @"社团群体 十大", nil];
    
    titleLabel.text = [nameArray objectAtIndex:section];
    [myView addSubview:titleLabel];
    return myView;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *nameArray = [NSArray arrayWithObjects:@"今日十大", @"本站系统 十大", @"东南大学 十大", @"电脑技术 十大", @"学术科学 十大", @"艺术文化 十大", @"乡情校谊 十大", @"休闲娱乐 十大", @"知性感性 十大", @"人文信息 十大", @"体坛风暴 十大", @"校务信箱 十大", @"社团群体 十大", nil];
    return [nameArray objectAtIndex:section];
}
*/

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

    NSArray *nameArray = [NSArray arrayWithObjects:@"今", @"本", @"东", @"电", @"学", @"艺", @"乡", @"休", @"知", @"人", @"体", @"校", @"社", nil];
    for(int i = 0; i < [nameArray count]; i++) {
        if([title isEqualToString:[nameArray objectAtIndex:i]]) {
            return i;
        }
    }
    return -1;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"今", @"", @"本", @"", @"东", @"", @"电", @"",
                          @"学", @"", @"艺", @"", @"乡", @"", @"休", @"",
                          @"知", @"", @"人", @"", @"体", @"", @"校", @"",
                          @"社", nil];
    return nameArray;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [topTenArray count];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [topTenArray objectAtIndex:section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identi = @"TopTenTableViewCell";
    TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Topic * topic = [[topTenArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.time = topic.time;
    cell.author = topic.author;
    cell.replies = topic.replies;
    cell.read = topic.read;
    cell.board = topic.board;
    cell.unread = YES;
    cell.top = topic.top;
    cell.time = topic.time;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 80;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Topic * topic = [[topTenArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.homeViewController.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSMutableArray * allArray = [[NSMutableArray alloc] init];
        NSArray *array;
        array = [BBSAPI topTen];
        if (array != nil) {
            [allArray addObject:[BBSAPI topTen]];
        }
        
        for (int i = 0; i < 12; i++) {
            array = [BBSAPI sectionTopTen:i];
            if (array != nil) {
                [allArray addObject:array];
            }
        }
        self.topTenArray = allArray;
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
