//
//  UploadAttachmentsViewController.m
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-2-3.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "UploadAttachmentsViewController.h"
@implementation UploadAttachmentsViewController
@synthesize mDelegate;
@synthesize postType;
@synthesize attList;
@synthesize board;
@synthesize image;
@synthesize postId;
@synthesize photos = _photos;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void) firstTimeLoad
{
    if (postType==0 || postType==1) {//新帖或回复
        self.attList = [BBSAPI getAttachmentsFromTopic:-1 andBoard:nil token:myBBS.mySelf.token];
    }
    else {  //修改
        self.attList = [BBSAPI getAttachmentsFromTopic:postId andBoard:board token:myBBS.mySelf.token];
    }
    
    [attTable reloadData];
    
    [activityView removeFromSuperview];
    activityView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 64)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"编辑附件";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    NSArray *rightItemsArray;
    UIBarButtonItem *pickFromAlbumButton = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(pickImageFromAlbum:)];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIBarButtonItem *pickFromCameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(pickImageFromCamera:)];
        rightItemsArray = [NSArray arrayWithObjects:pickFromCameraButton, pickFromAlbumButton, nil];
    }
    else{
        rightItemsArray = [NSArray arrayWithObjects:pickFromAlbumButton, nil];
    }
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = doneButton;
    self.navigationItem.rightBarButtonItems = rightItemsArray;

    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        attTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    }
    else {
        attTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }
    attTable.delegate = self;
    attTable.dataSource = self;
    [self.view addSubview:attTable];
    
    [activityView start];
    [self.view addSubview:activityView];
    [self performSelectorInBackground:@selector(firstTimeLoad) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pickImageFromAlbum:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)pickImageFromCamera:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.attList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    cell.textLabel.text=[[self.attList objectAtIndex:indexPath.row] attFileName];
    [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    curRow=indexPath.row;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"附件选项"
                                  delegate:self //actionSheet的代理，按钮被按下时收到通知，然后回调协议中的相关方法
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除"
                                  otherButtonTitles:@"预览",nil];
    //展示actionSheet
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == [actionSheet destructiveButtonIndex]){//确定
        //NSLog(@"确定");
        //执行删除操作
        [self doDelete];
    }else if(buttonIndex == [actionSheet cancelButtonIndex]){//取消
        
    }
    else{
        //预览附件
        //[self previewAtt];
    }
}

//预览附件
-(void) previewAtt
{
    NSString * curAttUrlString=[[self.attList objectAtIndex:curRow] attUrl];
    
    if ([curAttUrlString hasSuffix:@".png"] || [curAttUrlString hasSuffix:@".jpg"] || [curAttUrlString hasSuffix:@".jpeg"] || [curAttUrlString hasSuffix:@".JPEG"] || [curAttUrlString hasSuffix:@".PNG"] || [curAttUrlString hasSuffix:@".JPG"] || [curAttUrlString hasSuffix:@".tiff"] || [curAttUrlString hasSuffix:@".TIFF"] || [curAttUrlString hasSuffix:@".bmp"] || [curAttUrlString hasSuffix:@".BMP"]) {
        
        NSMutableArray * photosArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.attList count]; i++) {
            NSString * attUrlString=[[self.attList objectAtIndex:i] attUrl];
            if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".PNG"] || [attUrlString hasSuffix:@".JPG"] || [attUrlString hasSuffix:@".JPEG"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".TIFF"] || [attUrlString hasSuffix:@".bmp"] || [attUrlString hasSuffix:@".BMP"])
            //[photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:attUrlString]]];
                return;
        }
        self.photos = photosArray;
    }
    else if ([curAttUrlString hasSuffix:@".gif"] || [curAttUrlString hasSuffix:@".GIF"]) {
        
    }
    else{
        openString = curAttUrlString;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用Safari打开此附件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好",nil];
        [alert show];
    }
}

//处理safari打开附件
#pragma mark -
#pragma mark UIAlertView
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex){
        case 0:
            break;
        case 1:
        {
            NSURL* url = [[NSURL alloc] initWithString:openString];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
    }
}

-(void)doDelete
{
    int attid=[[self.attList objectAtIndex:curRow] attId];
    NSString * delUrlString;
    if (postType==0 || postType==1) {//新帖或者回复
        delUrlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/delete.js?token=%@&attid=%d",myBBS.mySelf.token,attid];
    }
    else{
        
        delUrlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/delete.js?token=%@&board=%@&id=%d&attid=%d",myBBS.mySelf.token,board,postId,attid];
    }
    NSURL *delUrl=[NSURL URLWithString:delUrlString];
    self.attList = [BBSAPI delImg:delUrl];
    [attTable reloadData];
}


-(NSString *)stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    NSString* uuidString = [NSString stringWithString:(__bridge NSString*)strRef];
    CFRelease(strRef);
    CFRelease(uuidObj);
    return uuidString;
}


-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];

    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageFileName = [NSString stringWithFormat:@"%@.%@",[self stringWithUUID],@"JPG"];
    
    NSString *urlString;
    
    if (postType==0 || postType==1) {//新帖或者回复
        urlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/add.js?token=%@",myBBS.mySelf.token];
    }
    else{
        urlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/add.js?token=%@&board=%@&id=%d",myBBS.mySelf.token,board,postId];
    }
    theUrl=[NSURL URLWithString:urlString];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:5];
	HUD.labelText = @"上传中...";
    [HUD showWhileExecuting:@selector(uploadImage) onTarget:self withObject:nil animated:YES];
}

- (UIImage *)image: (UIImage *)oldimage fillSize: (CGSize) viewsize

{
    CGSize size = oldimage.size;
    
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(viewsize);
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [oldimage drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

-(void)uploadImage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    int uploadImage = [defaults integerForKey:@"uploadImage"];
    UIImage * newImage = [self image:self.image fillSize:CGSizeMake(self.image.size.width/(uploadImage+1), self.image.size.height/(uploadImage+1))];
    
    self.attList = [BBSAPI postImg:imageFileName Image:newImage toUrl:theUrl];
    [HUD removeFromSuperview];
    [attTable reloadData];
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
