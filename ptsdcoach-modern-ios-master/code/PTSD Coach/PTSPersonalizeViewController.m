//
//  PTSPersonalizeViewController.m
//  PTSD Coach
//

#import "PTSPersonalizeViewController.h"
#import "PTSBasicTableViewCell.h"
#import "PTSContactsViewController.h"
#import "PTSDatastore.h"
#import "PTSPhotosViewController.h"
#import "PTSSongsViewController.h"

static NSDictionary *sCellTitleMappings;

typedef NS_ENUM(NSInteger, PTSPersonalizeViewTableSection) {
  PTSPersonalizeViewTableSectionSoothing = 0,
  PTSPersonalizeViewTableSectionMindful = 1,
  PTSPersonalizeViewTableSectionContacts = 2
};

typedef NS_ENUM(NSInteger, PTSPersonalizeViewTableRow) {
  // Soothing Section
  PTSPersonalizeViewTableRowSoothingPhotos = 0,
  PTSPersonalizeViewTableRowSoothingSongs = 1,
  
  // Mindful Section
  PTSPersonalizeViewTableRowMindfulPhotos = 0,
  PTSPersonalizeViewTableRowMindfulSongs = 1,
  
  // Contacts
  PTSPersonalizeViewTableRowSupportContacts = 0
};

#pragma mark - Implementation

@implementation PTSPersonalizeViewController

#pragma mark - Class Methods

/**
 *  initalize
 */
+ (void)initialize {
  sCellTitleMappings = @{
                         @(PTSPersonalizeViewTableSectionSoothing) :
                           @{ @(PTSPersonalizeViewTableRowSoothingPhotos) : NSLocalizedString(@"Choose Soothing Pictures", nil),
                              @(PTSPersonalizeViewTableRowSoothingSongs): NSLocalizedString(@"Choose Soothing Songs", nil) },
                         
                         @(PTSPersonalizeViewTableSectionMindful) :
                           @{ @(PTSPersonalizeViewTableRowMindfulPhotos): NSLocalizedString(@"Choose Mindful Pictures", nil),
                              @(PTSPersonalizeViewTableRowMindfulSongs): NSLocalizedString(@"Choose Mindful Songs", nil) },
                         
                         @(PTSPersonalizeViewTableSectionContacts) :
                           @{ @(PTSPersonalizeViewTableRowSupportContacts): NSLocalizedString(@"Choose Support Contacts", nil) }
                         };
}

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  [self.tableView registerClass:[PTSBasicTableViewCell class] forCellReuseIdentifier:PTSTableCellIdentifierBasic];
  
  // Normally a 'Back' button is displayed to return to the previous view controller, but if
  // Personalization is taking place during the first-launch sequence, then we show a 'Done'
  // button instead. 
  if (self.shouldShowDoneButton) {
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:nil
                                                                                    action:@selector(showApplicationStoryboard:)];
    self.navigationItem.leftBarButtonItem = doneButtonItem;
  }
}

#pragma mark - UITableViewDataSource Methods

/**
 *  numberOfSectionsInTableView
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == PTSPersonalizeViewTableSectionSoothing || section == PTSPersonalizeViewTableSectionMindful) {
    return 2;
  }
  
  return 1;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSBasicTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierBasic];
  cell.primaryText = sCellTitleMappings[@(indexPath.section)][@(indexPath.row)];
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case PTSPersonalizeViewTableSectionSoothing: {
      if (indexPath.row == PTSPersonalizeViewTableRowSoothingPhotos) {
        [self showSoothingPhotosPicker];
      } else if (indexPath.row == PTSPersonalizeViewTableRowSoothingSongs) {
        [self showSoothingSongsPicker];
      }

      break;
    }
      
    case PTSPersonalizeViewTableSectionMindful: {
      if (indexPath.row == PTSPersonalizeViewTableRowMindfulPhotos) {
        [self showMindfulPhotosPicker];
      } else if (indexPath.row == PTSPersonalizeViewTableRowMindfulSongs) {
        [self showMindfulSongsPicker];
      }
      
      break;
    }
      
    case PTSPersonalizeViewTableSectionContacts: {
      if (indexPath.row == PTSPersonalizeViewTableRowSupportContacts) {
        [self showSupportContactsPicker];
      }
      
      break;
    }
  }
}

#pragma mark - Private Methods

/**
 *  showMindfulPhotosPicker
 */
- (void)showMindfulPhotosPicker {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSPhotosStoryboard" bundle:nil];
  PTSPhotosViewController *photosViewController = [storyboard instantiateInitialViewController];
  
  photosViewController.photos = [[PTSDatastore sharedDatastore] mindfulPhotos];
  photosViewController.title = NSLocalizedString(@"Mindful Pictures", nil);
  photosViewController.callbackBlock = ^(NSArray *photos) {
    [[PTSDatastore sharedDatastore] setMindfulPhotos:photos];
  };
  
  [self.navigationController pushViewController:photosViewController animated:YES];
}

/**
 *  showMindfulSongsPicker
 */
- (void)showMindfulSongsPicker {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSSongsStoryboard" bundle:nil];
  PTSSongsViewController *songsViewController = [storyboard instantiateInitialViewController];
  
  songsViewController.mediaItems = [[PTSDatastore sharedDatastore] mindfulSongs];
  songsViewController.title = NSLocalizedString(@"Mindful Songs", nil);
  songsViewController.callbackBlock = ^(NSArray *mediaIdentifiers) {
    [[PTSDatastore sharedDatastore] setMindfulSongs:mediaIdentifiers];
  };
  
  [self.navigationController pushViewController:songsViewController animated:YES];
}

/**
 *  showSoothingPhotosPicker
 */
- (void)showSoothingPhotosPicker {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSPhotosStoryboard" bundle:nil];
  PTSPhotosViewController *photosViewController = [storyboard instantiateInitialViewController];
  
  photosViewController.photos = [[PTSDatastore sharedDatastore] soothingPhotos];
  photosViewController.title = NSLocalizedString(@"Soothing Pictures", nil);
  photosViewController.callbackBlock = ^(NSArray *photos) {
    [[PTSDatastore sharedDatastore] setSoothingPhotos:photos];
  };
  
  [self.navigationController pushViewController:photosViewController animated:YES];
}

/**
 *  showSoothingSongsPicker
 */
- (void)showSoothingSongsPicker {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSSongsStoryboard" bundle:nil];
  PTSSongsViewController *songsViewController = [storyboard instantiateInitialViewController];
  
  songsViewController.mediaItems = [[PTSDatastore sharedDatastore] soothingSongs];
  songsViewController.title = NSLocalizedString(@"Soothing Songs", nil);
  songsViewController.callbackBlock = ^(NSArray *mediaIdentifiers) {
    [[PTSDatastore sharedDatastore] setSoothingSongs:mediaIdentifiers];
  };
  
  [self.navigationController pushViewController:songsViewController animated:YES];
}

/**
 *  showSupportContactsPicker
 */
- (void)showSupportContactsPicker {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSContactsStoryboard" bundle:nil];
  PTSContactsViewController *contactsViewController = [storyboard instantiateInitialViewController];
  contactsViewController.title = NSLocalizedString(@"Support Contacts", nil);

  [self.navigationController pushViewController:contactsViewController animated:YES];
}

@end
