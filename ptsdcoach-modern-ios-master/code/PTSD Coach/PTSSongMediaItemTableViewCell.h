//
//  PTSSongMediaItemTableViewCell.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

@class MPMediaItem;

@interface PTSSongMediaItemTableViewCell : UITableViewCell

// Public Methods
- (void)prepareWithMediaItem:(MPMediaItem *)mediaItem;

@end
