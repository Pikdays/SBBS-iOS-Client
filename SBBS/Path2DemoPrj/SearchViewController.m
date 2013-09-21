//
//  SearchViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController
@synthesize searchString;
@synthesize seg;
@synthesize searchBoardViewController;
@synthesize searchTopicViewController;
@synthesize searchUserViewController;

- (id)init
{
    self = [super init];
    if (self) {
        self.searchBoardViewController = [[SearchBoardViewController alloc] init];
        self.searchTopicViewController = [[SearchTopicViewController alloc] init];
        self.searchUserViewController = [[SearchUserViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //[self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 64)];
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    NSArray * itemArray = [NSArray arrayWithObjects:@"版面", @"文章", @"用户", nil];
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
    
    [searchBoardViewController.view setFrame:CGRectMake(0, 44, self.view.frame.size.width, rect.size.height - 108)];
    [searchTopicViewController.view setFrame:CGRectMake(0, 44, self.view.frame.size.width, rect.size.height - 108)];
    [searchUserViewController.view setFrame:CGRectMake(0, 44, self.view.frame.size.width, rect.size.height - 108)];
    
    [self.view insertSubview:searchBoardViewController.view atIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    searchBoardViewController = nil;
    searchTopicViewController = nil;
    searchUserViewController = nil;
}

-(void)refreshSearching
{
    searchBoardViewController.searchString = searchString;
    searchTopicViewController.searchString = searchString;
    searchUserViewController.searchString = searchString;
    [searchBoardViewController reloadData];
    [searchTopicViewController reloadData];
    [searchUserViewController reloadData];
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    switch (myUISegmentedControl.selectedSegmentIndex) {
        case 0:
            [searchTopicViewController.view removeFromSuperview];
            [searchUserViewController.view removeFromSuperview];
            [self.view insertSubview:searchBoardViewController.view atIndex:0];
            break;
        case 1:
            [searchBoardViewController.view removeFromSuperview];
            [searchUserViewController.view removeFromSuperview];
            [self.view insertSubview:searchTopicViewController.view atIndex:0];
            break;
        case 2:
            [searchTopicViewController.view removeFromSuperview];
            [searchBoardViewController.view removeFromSuperview];
            [self.view insertSubview:searchUserViewController.view atIndex:0];
            break;
        default:
            break;
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
