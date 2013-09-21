//
//  SingleTopicViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicViewController.h"
#import "CXPhotoBrowser.h"
#import "DemoPhoto.h"

@implementation SingleTopicViewController
@synthesize rootTopic;
@synthesize isForShowNotification;
@synthesize mDelegate;
@synthesize customTableView;
@synthesize selectedCell;
@synthesize forRetainController;

- (id)initWithRootTopic:(Topic *)topic
{
    self = [super init];
    if (self) {
        isForShowNotification = NO;
        topicsArray = [[NSMutableArray alloc] init];
        self.rootTopic = topic;
    }
    return self;
}

-(void)firstTimeLoad
{
    NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:0 Token:myBBS.mySelf.token];
    if (topics == nil) {
        [activityView stop];
        [activityView removeFromSuperview];
        activityView = nil;
        return;
    }
    
    [topicsArray addObjectsFromArray:topics];
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];

    UIBarButtonItem *replyButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(reply)];
    Topic * newRootTopic = [topicsArray objectAtIndex:0];
    NSArray * array;
    if (newRootTopic.ID == newRootTopic.gID) {
        array = [NSArray arrayWithObjects:replyButton, nil];
    }
    else{
        UIBarButtonItem *expandButton = [[UIBarButtonItem alloc] initWithTitle:@"同主题展开" style:UIBarButtonItemStylePlain target:self action:@selector(expand)];
        array = [NSArray arrayWithObjects:replyButton, expandButton, nil];
    }
    
    if (self.navigationController != nil) {
        self.navigationItem.rightBarButtonItems = array;
    }
    else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.homeViewController.navigationItem.rightBarButtonItems = array;
    }
    
    [activityView stop];
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
    myBBS = appDelegate.myBBS;
    
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    if (IS_IOS7 && self.navigationController != nil) {
        customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    }
    else {
        customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }
    
    
    [self.view addSubview:customTableView];
    
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)dealloc
{
}
-(IBAction)back:(id)sender
{
    if (isForShowNotification) {
        [mDelegate refreshNotification];
    }
    selectedCell.unread = FALSE;
    
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark tableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topicsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        SingleTopicCell * cell = (SingleTopicCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.title = topic.title;
        cell.content = topic.content;
        cell.content = topic.content;
        cell.attachments = topic.attachments;
        cell.indexRow = indexPath.row;
        cell.mDelegate = self;
        return cell;
    }
    else
    {
        SingleTopicCommentCell * cell = (SingleTopicCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCommentCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCommentCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.quote = topic.quote;
        cell.quoter = topic.quoter;
        cell.content = topic.content;
        cell.num = indexPath.row;
        cell.content = topic.content;
        cell.attachments = topic.attachments;
        cell.indexRow = indexPath.row;
        cell.mDelegate = self;
        return cell;
    }
}

-(NSArray *)getPicList:(NSArray *)attachments
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[[attachments objectAtIndex:i] attUrl] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            [picArray addObject:[attachments objectAtIndex:i]];
        }
    }
    return picArray;
}

-(NSArray *)getDocList:(NSArray *)attachments
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[[attachments objectAtIndex:i] attUrl] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            //[picArray addObject:[attachments objectAtIndex:i]];
        }
        else
        {
            [picArray addObject:[attachments objectAtIndex:i]];
        }
    }
    return picArray;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int returnHeight;
    if (indexPath.row == 0)
    {
        Topic * topic = [topicsArray objectAtIndex:0];
        
        UIFont *font = [UIFont systemFontOfSize:17.0];
        
        CGSize size2 = size2 = [topic.content sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width - 30, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
        if (ShowAttachments) {
            size2.height = size2.height + (400 * [[self getPicList:topic.attachments] count]);
            size2.height = size2.height + 60 * [[self getDocList:topic.attachments] count];
        }
        else{
            size2.height = size2.height + 60 * [topic.attachments count];
        }
        returnHeight = size2.height + 90;
    }
    else {
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        
        UIFont *font = [UIFont systemFontOfSize:17.0];
        UIFont *font2 = [UIFont boldSystemFontOfSize:12.0];
        CGSize size1 = [topic.content sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width - 30, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        CGSize size2 = [[NSString stringWithFormat:@"回复 %@：%@",topic.quoter, topic.quote] sizeWithFont:font2 constrainedToSize:CGSizeMake(self.view.frame.size.width - 30, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
        if (ShowAttachments) {
            size2.height = size2.height + (400 * [[self getPicList:topic.attachments] count]);
            size2.height = size2.height + 60 * [[self getDocList:topic.attachments] count];
        }
        else{
            size2.height = size2.height + 60 * [topic.attachments count];
        }
        returnHeight = size1.height + size2.height + 40;
    }
    return returnHeight;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectTopic = [topicsArray objectAtIndex:indexPath.row];
    [self showActionSheet];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:0 Token:myBBS.mySelf.token];
        [topicsArray removeAllObjects];
        [topicsArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)loadMoreTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:[topicsArray count] Token:myBBS.mySelf.token];
        [topicsArray addObjectsFromArray:topics];
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

- (void)reply
{
    if (myBBS.mySelf.ID == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
    else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
        postTopicViewController.postType = 1;
        postTopicViewController.rootTopic = rootTopic;
        postTopicViewController.mDelegate = appDelegate.homeViewController;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [appDelegate.homeViewController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)expand
{
    Topic * newRootTopic = [topicsArray objectAtIndex:0];
    if (newRootTopic.ID == newRootTopic.gID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"此帖已是主题帖";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"同主题展开";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
        
        [self performSelector:@selector(ShowgID) withObject:nil afterDelay:0.4];
    }
}

-(void)ShowgID
{
    Topic * newRootTopic = [topicsArray objectAtIndex:0];
    NSArray * topics = [BBSAPI singleTopic:newRootTopic.board ID:newRootTopic.gID Start:0 Token:myBBS.mySelf.token];
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:[topics objectAtIndex:0]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home.navigationController pushViewController:singleTopicViewController animated:YES];
}

-(void)showActionSheet
{
    NSMutableString * string = [@"" mutableCopy];
    [string appendString:selectTopic.author];
    //[string appendString:@"的帖子"];
    if ([myBBS.mySelf.ID isEqualToString:selectTopic.author]) {
        UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                     initWithTitle:string
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"回复", @"查看用户", @"修改帖子", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
    }
    else{
        UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                     initWithTitle:string
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"回复", @"查看用户" ,nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
    }
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {//0号为回复
        if (myBBS.mySelf.ID == nil) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请先登录";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        else {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
            postTopicViewController.postType = 1;
            postTopicViewController.rootTopic = selectTopic;
            postTopicViewController.mDelegate = appDelegate.homeViewController;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            [appDelegate.homeViewController presentViewController:nav animated:YES completion:nil];
        }
    }
    if(buttonIndex == 1)
    {//1号为查看用户资料
        UserInfoViewController * userInfoViewController;
        userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        userInfoViewController.userString = selectTopic.author;
        if (self.navigationController != nil) {
           [self presentPopupViewController:userInfoViewController animationType:MJPopupViewAnimationSlideTopBottom];
        }
        else {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.homeViewController presentPopupViewController:userInfoViewController animationType:MJPopupViewAnimationSlideTopBottom];
        }
    }
    
    if(buttonIndex == 2 && [myBBS.mySelf.ID isEqualToString:selectTopic.author])
    {//当前话题作者等于自己，2号即为修改文章
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
        postTopicViewController.postType = 2;
        postTopicViewController.rootTopic = selectTopic;
        postTopicViewController.mDelegate = appDelegate.homeViewController;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [appDelegate.homeViewController presentViewController:nav animated:YES completion:nil];
    }
} 


-(void)dismissPostTopicView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - SingleTopicCellDelegate
-(void)imageAttachmentViewInCellTaped:(int)indexRow Index:(int)indexNum
{
    NSMutableArray *photoDataSource = [[NSMutableArray alloc] init];
    Topic * topic = [topicsArray objectAtIndex:indexRow];
    NSArray * picArray = [self getPicList:topic.attachments];
    
    for (int i = 0; i < [picArray count]; i++)
    {
        Attachment * att = [picArray objectAtIndex:i];
        DemoPhoto *photo = [[DemoPhoto alloc] initWithURL:[NSURL URLWithString:att.attUrl]];
        [photoDataSource addObject:photo];
    }
    CXPhotoBrowser * browser = [[CXPhotoBrowser alloc] initWithPhotoArray:photoDataSource];
    [browser setInitialPageIndex:indexNum];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.homeViewController presentViewController:browser animated:YES completion:nil];
}

-(void)attachmentViewInCellTaped:(BOOL)isPhoto IndexRow:(int)indexRow IndexNum:(int)indexNum
{
    if (isPhoto) {
        NSMutableArray *photoDataSource = [[NSMutableArray alloc] init];
        Topic * topic = [topicsArray objectAtIndex:indexRow];
        NSArray * picArray = [self getPicList:topic.attachments];
        
        for (int i = 0; i < [picArray count]; i++)
        {
            Attachment * att = [picArray objectAtIndex:i];
            DemoPhoto *photo = [[DemoPhoto alloc] initWithURL:[NSURL URLWithString:att.attUrl]];
            [photoDataSource addObject:photo];
        }
        CXPhotoBrowser * browser = [[CXPhotoBrowser alloc] initWithPhotoArray:photoDataSource];
        [browser setInitialPageIndex:indexNum];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.homeViewController presentViewController:browser animated:YES completion:nil];
    }
    else {
        Topic * topic = [topicsArray objectAtIndex:indexRow];
        NSArray * docArray = [self getDocList:topic.attachments];
        Attachment * att = [docArray objectAtIndex:indexNum];
        
        WebViewController * webViewController = [[WebViewController alloc] initWithURL:att.attFileName AttachmentURL:[NSURL URLWithString:att.attUrl]];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.homeViewController presentViewController:nav animated:YES completion:nil];
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
