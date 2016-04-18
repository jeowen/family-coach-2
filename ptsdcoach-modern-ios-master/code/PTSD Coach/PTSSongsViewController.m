//
//  PTSSongsViewController.m
//  PTSD Coach
//

@import MediaPlayer;

#import "PTSSongsViewController.h"
#import "PTSSongMediaItemTableViewCell.h"

#pragma mark - Private Interface

@interface PTSSongsViewController()<MPMediaPickerControllerDelegate>

@property(nonatomic, strong) IBOutlet UILabel *noSongsLabel;

@end

#pragma mark - Implementation

@implementation PTSSongsViewController

#pragma mark - UIViewController

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Public Properties

/**
 *  setMediaItems
 */
- (void)setMediaItems:(NSArray *)mediaItems {
  _mediaItems = mediaItems;
  
  [self toggleEmptyMessageIfNecessary];
}

#pragma mark - IBActions

/**
 *  handleAddSongButton
 */
- (IBAction)handleAddSongButton:(id)sender {
  MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
  picker.allowsPickingMultipleItems = NO;
  picker.delegate = self;
  
  [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - MPMediaPickerControllerDelegate Methods

/**
 *  mediaPicker:didPickMediaItems
 */
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
  MPMediaItem *mediaItem = mediaItemCollection.items.firstObject;
  
  if (!self.mediaItems) {
    self.mediaItems = @[];
  }
  
  self.mediaItems = [self.mediaItems arrayByAddingObject:mediaItem];
  
  [self toggleEmptyMessageIfNecessary];
  [self.tableView reloadData];
  
  if (self.callbackBlock) {
    self.callbackBlock(self.mediaItems);
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  mediaPickerDidCancel
 */
- (void) mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  numberOfSectionsInTableView
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.mediaItems.count;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSSongMediaItemTableViewCell *mediaItemCell = [tableView dequeueReusableCellWithIdentifier:@"SongItemTableViewCellIdentifier" forIndexPath:indexPath];

  MPMediaItem *mediaItem = self.mediaItems[indexPath.row];
  [mediaItemCell prepareWithMediaItem:mediaItem];
  
  return mediaItemCell;
}

/**
 *  canEditRowAtIndexPath
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

/**
 *  tableView:commitEditingStyle
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    MPMediaItem *mediaItemToRemove = self.mediaItems[indexPath.row];
    NSMutableArray *mutableMediaItems = [[NSMutableArray alloc] initWithArray:self.mediaItems];
    [mutableMediaItems removeObject:mediaItemToRemove];
    
    self.mediaItems = [mutableMediaItems copy];

    [self toggleEmptyMessageIfNecessary];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.callbackBlock) {
      self.callbackBlock(self.mediaItems);
    }
  }
}

#pragma mark - Private Methods

/**
 *  toggleEmptyMessageIfNecessary
 */
- (void)toggleEmptyMessageIfNecessary {
  // The tableView's tableFooterView works a bit nicer than its backgroundView because
  // the tableFooterView will bounce if the user interacts with the table view. As well,
  // when using a tableFooterView, the tableView will hide any empty rows and their
  // respective divider lines.
  
  if (self.mediaItems.count > 0) {
    self.tableView.tableFooterView = nil;
  } else {
    self.tableView.tableFooterView = self.noSongsLabel;
  }
}

@end
