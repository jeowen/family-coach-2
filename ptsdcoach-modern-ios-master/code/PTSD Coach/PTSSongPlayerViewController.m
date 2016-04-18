//
//  PTSSongPlayerViewController.m
//  PTSD Coach
//

@import MediaPlayer;

#import "PTSSongPlayerViewController.h"
#import "PTSAudioControlsView.h"
#import "PTSDatastore.h"
#import "PTSRandomContentProvider.h"
#import "PTSSongsViewController.h"

static NSString *const PTSSegueIdentifierShowSongs = @"ShowSongsSegue";

@interface PTSSongPlayerViewController()

@property(nonatomic, weak) IBOutlet UILabel *emptyListLabel;

@property(nonatomic, weak) IBOutlet UIButton *currentSongButton;
@property(nonatomic, weak) IBOutlet UIButton *editSongListButton;
@property(nonatomic, weak) IBOutlet UIStackView *musicAppStackView;
@property(nonatomic, weak) IBOutlet PTSAudioControlsView *audioControlsView;

@property(nonatomic, strong) MPMediaItem *currentMediaItem;
@property(nonatomic, strong) PTSRandomContentProvider *randomContentProvider;

@end

#pragma mark - Implementation

@implementation PTSSongPlayerViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoag
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.isEmbeddedInContainerView) {
    self.view.layoutMargins = UIEdgeInsetsZero;
  }

  self.currentSongButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  
  if (self.listSource == PTSSongPlayerListSourceMindfulListening) {
    [self updateViewWithMediaItems:[PTSDatastore sharedDatastore].mindfulSongs];
  } else if (self.listSource == PTSSongPlayerListSourceSoothingAudio) {
    [self updateViewWithMediaItems:[PTSDatastore sharedDatastore].soothingSongs];
  }
}

/**
 *  prepareForSegue:sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierShowSongs]) {
    PTSSongsViewController *songsViewController = (PTSSongsViewController *)segue.destinationViewController;
    songsViewController.mediaItems = self.randomContentProvider.contentItems;
    songsViewController.navigationItem.title = self.songPickerViewTitle;
    songsViewController.hidesBottomBarWhenPushed = YES;
    songsViewController.callbackBlock = ^(NSArray *mediaItems) {
      if (self.listSource == PTSSongPlayerListSourceMindfulListening) {
        [PTSDatastore sharedDatastore].mindfulSongs = mediaItems;
      } else if (self.listSource == PTSSongPlayerListSourceSoothingAudio) {
        [PTSDatastore sharedDatastore].soothingSongs = mediaItems;
      }

      [self updateViewWithMediaItems:mediaItems];
    };
  }
}

#pragma mark - IBAction

/**
 *  handleCurrentSongButtonPressed
 */
- (IBAction)handleCurrentSongButtonPressed:(id)sender {
  [self updateCurrentMediaItem];
}

/**
 *  handlePlayMusicAppButtonPressed
 */
- (IBAction)handlePlayMusicAppButtonPressed:(id)sender {
  MPMusicPlayerController *musicPlayer = [MPMusicPlayerController systemMusicPlayer];
  
  [musicPlayer stop];
  
  MPMediaItemCollection *collection = [[MPMediaItemCollection alloc] initWithItems:@[self.currentMediaItem]];
  MPMediaItem *item = [collection representativeItem];
  
  [musicPlayer setQueueWithItemCollection:collection];
  [musicPlayer setNowPlayingItem:item];
  
  [musicPlayer prepareToPlay];
  [musicPlayer play];
  
  NSString *stringURL = @"music:";
  NSURL *url = [NSURL URLWithString:stringURL];
  [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Private Methods

/**
 *  updateViewWithMediaItems
 */
- (void)updateViewWithMediaItems:(NSArray *)mediaItems {
  self.randomContentProvider = [[PTSRandomContentProvider alloc] initWithContentItems:mediaItems];
  self.emptyListLabel.hidden = (mediaItems.count > 0);
  self.currentSongButton.hidden = (mediaItems.count == 0);
  self.audioControlsView.hidden = (mediaItems.count == 0);
  self.musicAppStackView.hidden = YES;
  
  if (mediaItems.count > 0) {
    [self updateCurrentMediaItem];
  }
}

/**
 *  updateCurrentMediaItem
 */
- (void)updateCurrentMediaItem {
  NSAssert(self.randomContentProvider.itemCount > 0, @"Cannot update current media items when there are no media items.");
  
  self.currentMediaItem = [self.randomContentProvider nextContentItem];
  
  NSMutableArray *mutableButtonTitle = [[NSMutableArray alloc] init];
  NSString *songTitle = [self.currentMediaItem valueForProperty: MPMediaItemPropertyTitle];
  NSString *songArtist = [self.currentMediaItem valueForProperty:MPMediaItemPropertyArtist];
  NSURL *audioURL = [self.currentMediaItem valueForProperty:MPMediaItemPropertyAssetURL];
  
  if (songArtist.length > 0) {
    [mutableButtonTitle addObject:songArtist];
  }

  if (songTitle.length  > 0) {
    [mutableButtonTitle addObject:songTitle];
  }
  
  if (audioURL) {
    self.musicAppStackView.hidden = YES;
    self.audioControlsView.hidden = NO;
    
    [self.audioControlsView loadAudioFileWithURL:audioURL autoplay:NO];
  } else {
    self.musicAppStackView.hidden = NO;
    self.audioControlsView.hidden = YES;
  }
  
  [self.currentSongButton setTitle:[mutableButtonTitle componentsJoinedByString:@"\n"] forState:UIControlStateNormal];
}

@end
