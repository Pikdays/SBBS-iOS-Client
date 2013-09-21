//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

#define kTriggerOffSet 100.0f
#define homeViewOffSet 220.0f

/////////////////////////////////////
@interface HomeViewController () 
- (void)restoreViewLocation;
- (void)moveToRightSide;
- (void)animateHomeViewToSide:(CGRect)newViewRect;
@end

/////////////////////////////////////
@implementation HomeViewController
@synthesize realViewController;
@synthesize mDelegate;


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
     CGPoint translation = [gestureRecognizer translationInView:[[UIApplication sharedApplication] keyWindow]];
 
     if (sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1)
     {
        return YES;
     }
     return NO;
}
 
- (void)handlePanFrom:(UIPanGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        ;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (self.navigationController.view.frame.origin.x < -kTriggerOffSet)
            {
            
            }
            else if (self.navigationController.view.frame.origin.x > kTriggerOffSet)
            {
                AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (appdelegate.isSearching) {
                    [appdelegate showLeftViewTotaly];
            }
            else {
                [self moveToRightSide];
            }
        }
        else
            [self restoreViewLocation];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
         CGFloat xOffSet = [recognizer translationInView:[[UIApplication sharedApplication] keyWindow]].x;
         if (xOffSet >= 0 && xOffSet <= 320) {
             self.navigationController.view.frame = CGRectMake(xOffSet,
                                                           self.navigationController.view.frame.origin.y,
                                                           self.navigationController.view.frame.size.width,
                                                           self.navigationController.view.frame.size.height);
         }
     }
}

- (void)awakeFromNib {
    UIPanGestureRecognizer* recognizer;
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.realViewController = [[TopTenViewController alloc] init];
    [self.realViewController.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self showViewController:@"热门帖子"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (IS_IOS7) {
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
    }
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarBtnTapped:)];
    self.navigationItem.leftBarButtonItem = menuButton;
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


#pragma mark -
#pragma mark Other methods

// restore view location
- (void)restoreViewLocation {
    homeViewIsOutOfStage = NO;
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.navigationController.view.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
                     } 
                     completion:^(BOOL finished){
                         UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
                         if (overView != nil)
                             [overView removeFromSuperview];
                     }];
}

// move view to right side
- (void)moveToRightSide {
    homeViewIsOutOfStage = YES;
    [self animateHomeViewToSide:CGRectMake(homeViewOffSet,
                                           self.navigationController.view.frame.origin.y, 
                                           self.navigationController.view.frame.size.width, 
                                           self.navigationController.view.frame.size.height)];
}
- (void)moveToRightSideTotaly {
    homeViewIsOutOfStage = YES;
    [self animateHomeViewToSideTotaly:CGRectMake(self.view.frame.size.width + 20,
                                           self.navigationController.view.frame.origin.y, 
                                           self.navigationController.view.frame.size.width, 
                                           self.navigationController.view.frame.size.height)];
}
- (void)animateHomeViewToSideTotaly:(CGRect)newViewRect {
    UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
    if (overView != nil)
        [overView removeFromSuperview];
    [UIView animateWithDuration:0.2 
                     animations:^{
                         self.navigationController.view.frame = newViewRect;
                     }
                     completion:^(BOOL finished){
                         UIControl *overView = [[UIControl alloc] init];
                         overView.tag = 10086;
                         overView.backgroundColor = [UIColor clearColor];
                         overView.frame = self.navigationController.view.frame;
                         [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
                         [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
                     }];
}
- (void)animateHomeViewToSide:(CGRect)newViewRect {
    UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
    if (overView != nil)
        [overView removeFromSuperview];
    [UIView animateWithDuration:0.2 
                     animations:^{
                         self.navigationController.view.frame = newViewRect;
                     } 
                     completion:^(BOOL finished){
                         UIControl *overView = [[UIControl alloc] init];
                         overView.tag = 10086;
                         overView.backgroundColor = [UIColor clearColor];
                         overView.frame = self.navigationController.view.frame;
                         [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
                         [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
                     }];
}


// handle left bar btn
- (IBAction)leftBarBtnTapped:(id)sender {
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.isSearching) {
        [appdelegate showLeftViewTotaly];
    }
    else {
        [self moveToRightSide];
    }
}
- (void)removeOldViewController
{
    if (self.realViewController != nil) {
        [self.realViewController.view removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = nil;
    }
}
- (void)showViewController:(NSString *)topTitleString
{
    self.title = topTitleString;
    [self.view insertSubview:self.realViewController.view atIndex:0];
}

#pragma -
#pragma mark TopTenViewController delegate
-(void)topTenCellSelected:(Topic *)topic
{
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
}


-(void)dismissPostTopicView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
