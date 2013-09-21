//
//  NotificationViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MailBoxViewController.h"

@implementation MailBoxViewController
@synthesize mailsArray;
@synthesize seg;

- (id)init
{
    self = [super init];
    if (self) {
        self.mailsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)firstTimeLoad
{
    NSArray * topics = [BBSAPI getMails:myBBS.mySelf.token Type:seg.selectedSegmentIndex Start:0];
    [self.mailsArray addObjectsFromArray:topics];
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    customTableView = [[CustomTableWithDeleteView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 108) Delegate:self];
    [self.view addSubview:customTableView];
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    NSArray * itemArray = [NSArray arrayWithObjects:@"收件箱", @"发件箱", @"废件箱", nil];
    self.seg = [[UISegmentedControl alloc] initWithItems:itemArray];
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
    
    UIBarButtonItem *newMailButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMail:)];
    //UIBarButtonItem *newMailButton=[[UIBarButtonItem alloc] initWithTitle:@"新邮件" style:UIBarButtonItemStylePlain target:self action:@selector(newMail:)];
    appDelegate.homeViewController.navigationItem.rightBarButtonItem = newMailButton;
    
    myBBS = appDelegate.myBBS;
    
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)dealloc
{
    customTableView = nil;
    
}

#pragma mark - 
#pragma mark tableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mailsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailsViewCell * cell = (MailsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MailsViewCell"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MailsViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Mail * mail = [mailsArray objectAtIndex:indexPath.row];
    cell.mail = mail;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SingleMailViewController * singleMailViewController = [[SingleMailViewController alloc] initWithNibName:@"SingleMailViewController" bundle:nil];
    singleMailViewController.rootMail = [mailsArray objectAtIndex:indexPath.row];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshNotification];
    HomeViewController * home = appDelegate.homeViewController;
    [home.navigationController pushViewController:singleMailViewController animated:YES];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Mail * mail = [mailsArray objectAtIndex:indexPath.row];
    BOOL success = [BBSAPI deleteSingleMail:myBBS.mySelf.token Type:mail.type ID:mail.ID];
    if (success) {
        NSMutableArray * newTopTen = [[NSMutableArray alloc] init];
        for (int i = 0; i < [mailsArray count]; i++) {
            if (i != indexPath.row) {
                [newTopTen addObject:[mailsArray objectAtIndex:i]];
            }
        }
        self.mailsArray = newTopTen;
        [customTableView.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(IBAction)newMail:(id)sender
{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] init];
    postMailViewController.postType = 0;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailViewController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [appdelegate.homeViewController presentViewController:nav animated:YES completion:nil];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI getMails:myBBS.mySelf.token Type:seg.selectedSegmentIndex Start:0];
        [self.mailsArray removeAllObjects];
        [self.mailsArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)refreshTableView
{
    [customTableView reloadData];
    
    [activityView removeFromSuperview];
    activityView = nil;
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}

-(void)loadMoreTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI getMails:myBBS.mySelf.token Type:seg.selectedSegmentIndex Start:[mailsArray count]];
        [self.mailsArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(loadMoreTable) toTarget:self withObject:nil];
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    [activityView removeFromSuperview];
    activityView = nil;
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(refreshTable) withObject:nil];
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
