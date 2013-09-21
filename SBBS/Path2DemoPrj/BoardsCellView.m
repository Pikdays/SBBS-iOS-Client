//
//  BoardsCellView.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/2/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BoardsCellView.h"

@implementation BoardsCellView
@synthesize name;
@synthesize description;
@synthesize section;
@synthesize leaf;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;

        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, 155, 21)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        nameLabel.textAlignment = NSTextAlignmentRight;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [nameLabel setFrame:CGRectMake(0, 11, 370, 28)];
        }
        [self addSubview:nameLabel];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 11, 155, 21)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        descriptionLabel.adjustsFontSizeToFitWidth = YES;
		descriptionLabel.textColor = [UIColor lightGrayColor];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [descriptionLabel setFrame:CGRectMake(398, 11, 370, 21)];
        }
        [self addSubview:descriptionLabel];
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
    [nameLabel setText:name];
    [descriptionLabel setText:description];
}

@end
