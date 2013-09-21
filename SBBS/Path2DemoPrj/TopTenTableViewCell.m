//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopTenTableViewCell.h"
#import "BBSAPI.h"

@implementation TopTenTableViewCell
@synthesize ID;
@synthesize title;
@synthesize author;
@synthesize board;
@synthesize time;
@synthesize replies;
@synthesize read;
@synthesize unread;
@synthesize top;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
    
    if (unread) {
        [articleTitleLabel setAlpha:1];
    }
    else
    {
        [articleTitleLabel setAlpha:0.4];
    }
    
    [isTop setHidden:!top];
    [articleTitleLabel setText:[NSString stringWithFormat:@"%@", title]];
    [authorLabel setText:[NSString stringWithFormat:@"%@", author]];
    [readandreplyLabel setText:[NSString stringWithFormat:@"%i/%i", replies, read]];
    if (board != nil) {
        [boardLabel setText:[NSString stringWithFormat:@"%@ 版", board]];
    }
    else {
        [boardLabel setText:@""];
    }
    [articleDateLabel setText:[BBSAPI dateToString:time]];
}
@end
