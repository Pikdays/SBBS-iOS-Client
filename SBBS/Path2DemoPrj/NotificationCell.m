//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize notification;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        [self.textLabel setText:@"新消息"];
        
        notificationView = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 300, 34)];
        [notificationView setBackgroundColor:[UIColor redColor]];
        notificationView.layer.cornerRadius = 17.0f;
        notificationView.clipsToBounds = YES;
        [self addSubview:notificationView];
        
        notificationCount = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 42, 34)];
        notificationCount.backgroundColor = [UIColor clearColor];
        notificationCount.font = [UIFont boldSystemFontOfSize:17];
        notificationCount.textColor = [UIColor redColor];
        notificationCount.highlightedTextColor = [UIColor redColor];
        notificationCount.textAlignment = NSTextAlignmentLeft;
        [self addSubview:notificationCount];
    }
    return self;
}

-(void)dealloc
{
    notificationCount = nil;
    notificationView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)refreshCell
{
    if (notification.count == 0) {
        //[self stop];
        [notificationView setHidden:YES];
        [notificationCount setText:@""];
    }
    else {
        //[notificationView setHidden:NO];
        [notificationCount setText:[NSString stringWithFormat:@"%i", notification.count]];
        [self start];
    }
}

-(void)start {
    [notificationView.layer removeAllAnimations];
    notificationView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse
                     animations:^{
                         notificationView.transform = CGAffineTransformMakeTranslation(-20, 0);
                     }
                     completion:nil
     ];
}

-(void)stop {
    [notificationView.layer removeAllAnimations];
}

@end
