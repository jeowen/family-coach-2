//
//  PTSSettingsRootViewController.m
//  PTSD Coach
//

#import "PTSSettingsRootViewController.h"
#import "PTSDatastore.h"
#import "PTSBasicTableViewCell.h"
#import "PTSDetailsTableViewCell.h"
#import "PTSSegmentedTextViewController.h"

static NSDictionary *sCellTitleMappings;
static NSDictionary *sSegueIdentifierMappings;

typedef NS_ENUM(NSInteger, PTSSettingsRootViewTableSection) {
  PTSSettingsRootViewTableSectionOptions = 0,
  PTSSettingsRootViewTableSectionAbout,
  PTSSettingsRootViewTableSectionVersion
};

typedef NS_ENUM(NSInteger, PTSSettingsRootViewTableRow) {
  // Options section
  PTSSettingsRootViewTableRowReminders = 0,
  PTSSettingsRootViewTableRowPersonalize,
  PTSSettingsRootViewTableRowManageData,
  
  // About section
  PTSSettingsRootViewTableRowAbout = 0,
  
  // Version Sesion
  PTSSettingsRootViewTableRowVersion = 0
};

#pragma mark - Implementation

@implementation PTSSettingsRootViewController

#pragma mark - Class Methods

/**
 *  initalize
 */
+ (void)initialize {
  sCellTitleMappings = @{
                         @(PTSSettingsRootViewTableSectionOptions) :
                           @{ @(PTSSettingsRootViewTableRowReminders) : NSLocalizedString(@"Reminders", nil),
                              @(PTSSettingsRootViewTableRowPersonalize): NSLocalizedString(@"Personalize", nil),
                              @(PTSSettingsRootViewTableRowManageData) : NSLocalizedString(@"Manage Data", nil) },
                         
                         @(PTSSettingsRootViewTableSectionAbout) :
                           @{ @(PTSSettingsRootViewTableRowAbout): NSLocalizedString(@"About PTSD Coach", nil) }
                         };
  
  sSegueIdentifierMappings = @{
                               @(PTSSettingsRootViewTableSectionOptions) :
                                 @{ @(PTSSettingsRootViewTableRowReminders) : @"SegueIdentifierShowReminders",
                                    @(PTSSettingsRootViewTableRowPersonalize): @"SegueIdentifierShowPersonalize",
                                    @(PTSSettingsRootViewTableRowManageData) : @"SegueIdentifierShowManageData" },
                               
                               @(PTSSettingsRootViewTableSectionAbout) :
                                 @{ @(PTSSettingsRootViewTableRowAbout): @"SegueIdentifierShowAbout" }
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
  [self.tableView registerClass:[PTSDetailsTableViewCell class] forCellReuseIdentifier:PTSTableCellIdentifierDetails];
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"SegueIdentifierShowAbout"]) {
    PTSSegmentedTextViewController *segmentedTextViewController = (PTSSegmentedTextViewController *)segue.destinationViewController;
    segmentedTextViewController.filename = @"Settings - About PTSD Coach.rtf";
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
  return (section == PTSSettingsRootViewTableSectionOptions ? 3 : 1);
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Special-case the "Version" cell.
  if (indexPath.section == PTSSettingsRootViewTableSectionVersion) {
    PTSDetailsTableViewCell *versionCell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierDetails];
    versionCell.accessoryType = UITableViewCellAccessoryNone;
    versionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    versionCell.primaryText = NSLocalizedString(@"Version", nil);
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];

    versionCell.secondaryText = [NSString stringWithFormat:@"%@ (%@)", version, build];

    return versionCell;
  }
  
  PTSBasicTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierBasic];
  cell.primaryText = sCellTitleMappings[@(indexPath.section)][@(indexPath.row)];
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *segueIdentifier = sSegueIdentifierMappings[@(indexPath.section)][@(indexPath.row)];
  if (segueIdentifier) {
    [self performSegueWithIdentifier:segueIdentifier sender:self];
  }
}

#pragma mark - IBActions

/**
 *  saveSettingsAndDismiss
 */
- (IBAction)saveSettingsAndDismiss:(id)sender {
  [[PTSDatastore sharedDatastore] save];
  [self dismissViewControllerAnimated:self completion:nil];
}

@end
