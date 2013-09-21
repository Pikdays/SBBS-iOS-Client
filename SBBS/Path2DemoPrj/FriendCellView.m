//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "FriendCellView.h"

@implementation FriendCellView
@synthesize user;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.clipsToBounds = YES;
        self.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize] * 1.3f];
        
        IDandName = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 270, 21)];
        IDandName.backgroundColor = [UIColor clearColor];
        IDandName.font = [UIFont fontWithName:@"Helvetica" size:18.f];
        IDandName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:IDandName];
        
        mode = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 270, 12)];
        mode.backgroundColor = [UIColor clearColor];
        mode.font = [UIFont fontWithName:@"Helvetica" size:10.f];
		mode.textColor = [UIColor lightGrayColor];
        mode.textAlignment = NSTextAlignmentLeft;
        [self addSubview:mode];
        
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
    [IDandName setText:[NSString stringWithFormat:@"%@ (%@)", user.ID, user.name]];
    [mode setText:user.mode];
    NSString * viewString = [user.ID length] >= 2 ? [[user.ID substringToIndex:2] uppercaseString]: [user.ID uppercaseString];
    
    [IDandNameView setText:viewString];
    
    backView.layer.cornerRadius = 18.0f;
    backView.clipsToBounds = YES;
}
@end
