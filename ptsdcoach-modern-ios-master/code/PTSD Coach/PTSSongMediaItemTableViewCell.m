//
//  PTSSongMediaItemTableViewCell.m
//  PTSD Coach
//

@import MediaPlayer;

#import "PTSSongMediaItemTableViewCell.h"

#pragma mark - Private Interface

@interface PTSSongMediaItemTableViewCell()

@property(nonatomic, weak) IBOutlet UILabel *primaryLabel;
@property(nonatomic, weak) IBOutlet UILabel *secondaryLabel;

@end

#pragma mark - Implementation

@implementation PTSSongMediaItemTableViewCell

#pragma mark - Public Methods

/**
 *  prepareWithMediaItem
 */
- (void)prepareWithMediaItem:(MPMediaItem *)mediaItem {
  self.primaryLabel.text = [mediaItem valueForProperty: MPMediaItemPropertyTitle];
  self.secondaryLabel.text = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
}

@end
