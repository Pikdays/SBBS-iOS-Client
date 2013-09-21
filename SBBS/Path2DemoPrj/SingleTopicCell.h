//
//  SingleTopicCell.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "AttachmentView.h"
#import "ImageAttachmentView.h"

@protocol SingleTopicCellDelegate <NSObject>
-(void)imageAttachmentViewInCellTaped:(int)indexRow Index:(int)indexNum;
-(void)attachmentViewInCellTaped:(BOOL)isPhoto IndexRow:(int)indexRow IndexNum:(int)indexNum;
@end

@interface SingleTopicCell : UITableViewCell<ImageAttachmentViewDelegate, AttachmentViewDelegate>
{
    IBOutlet UILabel * articleTitleLabel;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * contentLabel;
    IBOutlet UILabel * articleDateLabel;
    
    int ID;
    int read;
    NSDate * time;
    NSString * title;
    NSString * content;
    NSString * author;
    NSArray * attachments;

    NSMutableArray * attachmentsViewArray;
}

@property(nonatomic, assign)int ID;
@property(nonatomic, assign)int read;
@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * author;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSArray * attachments;
@property(nonatomic, strong)NSArray * attachmentsViewArray;

@property(nonatomic, assign)int indexRow;
@property(nonatomic, assign)id mDelegate;
@end
