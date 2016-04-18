//
//  PTSToolAmbientSoundsViewController.m
//  PTSD Coach
//

#import "PTSToolAmbientSoundsViewController.h"
#import "PTSAudioControlsView.h"
#import "PTSBasicTableViewCell.h"

static NSString *const PTSToolAmbientSoundItemKeyTitle = @"title";
static NSString *const PTSToolAmbientSoundItemKeyURL = @"URL";

static NSArray *sAmbientSoundItems;

#pragma mark - Private Interface

@interface PTSToolAmbientSoundsViewController()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet PTSAudioControlsView *audioControlsView;

@end

@implementation PTSToolAmbientSoundsViewController

#pragma mark - Class Methods

/**
 *  initialize
 */
+ (void)initialize {
  NSMutableArray *mutableAmbientSoundItems = [[NSMutableArray alloc] init];
  
  void (^addAmbientSoundItem)(NSString *, NSString *) = ^(NSString *title, NSString *filename) {
    NSParameterAssert(title != nil);
    NSParameterAssert(filename != nil);
    
    NSString *extension = [filename pathExtension];
    NSString *resourceName = [filename stringByDeletingPathExtension];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:resourceName withExtension:extension];
    NSAssert(fileURL != nil, @"Missing ambient sound for filename: %@", filename);
    
    if (fileURL) {
      NSDictionary *ambientSoundItem = @{ PTSToolAmbientSoundItemKeyTitle : title,
                                          PTSToolAmbientSoundItemKeyURL : fileURL };
      [mutableAmbientSoundItems addObject:ambientSoundItem];
    }
  };
  
  addAmbientSoundItem(NSLocalizedString(@"Beach", nil), @"Ambient Sound - Beach - Freesound 23724.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Country Road", nil), @"Ambient Sound - Country Road - Freesound 137111.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Crickets", nil), @"Ambient Sound - Crickets - Freesound 36599.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Dripping Water", nil), @"Ambient Sound - Dripping Water - Freesound 170025.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Forest", nil), @"Ambient Sound - Forest - Freesound 43661.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Frogs", nil), @"Ambient Sound - Frogs - Freesound 24139.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Marsh", nil), @"Ambient Sound - Marsh - Freesound 31579.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Public Pool", nil), @"Ambient Sound - Public Pool - Freesound 56740.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Rain", nil), @"Ambient Sound - Rain - Freesound 17084.mp3");
  addAmbientSoundItem(NSLocalizedString(@"Stream", nil), @"Ambient Sound - Stream - Freesound 30688.mp3");
  
  sAmbientSoundItems = [mutableAmbientSoundItems copy];
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
  return sAmbientSoundItems.count;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *item = sAmbientSoundItems[indexPath.row];
  PTSBasicTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierBasic];

  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.primaryText = item[PTSToolAmbientSoundItemKeyTitle];
  cell.representedObject = item;
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  for (PTSBasicTableViewCell *cell in tableView.visibleCells) {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  PTSBasicTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
  selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
  
  NSDictionary *ambientSound = selectedCell.representedObject;
  NSURL *URL = ambientSound[PTSToolAmbientSoundItemKeyURL];
  
  [self.audioControlsView loadAudioFileWithURL:URL autoplay:YES];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
