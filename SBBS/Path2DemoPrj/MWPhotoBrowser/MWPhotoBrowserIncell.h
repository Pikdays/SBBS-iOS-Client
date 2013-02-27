//
//  MWPhotoBrowser.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MWPhoto.h"
#import "MWPhotoProtocol.h"
#import "MWCaptionView.h"

// Debug Logging
#if 0 // Set to 1 to enable debug logging
#define MWLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define MWLog(x, ...)
#endif

// Delgate
@class MWPhotoBrowserIncell;
@protocol MWPhotoBrowserIncellDelegate <NSObject>
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowserIncell *)photoBrowser;
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowserIncell *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional
- (MWCaptionView *)photoBrowser:(MWPhotoBrowserIncell *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
@end


@interface MWPhotoBrowserIncell : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> 


@property (nonatomic) BOOL displayActionButton;

// Init
- (id)initWithPhotos:(NSArray *)photosArray  __attribute__((deprecated)); // Depreciated
- (id)initWithDelegate:(id <MWPhotoBrowserIncellDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setInitialPageIndex:(NSUInteger)index;

@end


