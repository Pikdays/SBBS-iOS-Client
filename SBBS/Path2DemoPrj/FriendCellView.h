//
//  FriendCellView.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface FriendCellView : UITableViewCell
{
    IBOutlet UIView * backView;
    IBOutlet UILabel * IDandName;
    IBOutlet UILabel * mode;
    IBOutlet UILabel * IDandNameView;
    User * user;
}
@property(nonatomic, strong)User * user;
@end
