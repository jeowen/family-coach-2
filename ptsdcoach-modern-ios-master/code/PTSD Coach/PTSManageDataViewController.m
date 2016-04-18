//
//  PTSManageDataViewController.m
//  PTSD Coach
//

#import "PTSManageDataViewController.h"
#import "PTSBasicTableViewCell.h"
#import "PTSDynamicTypeLabel.h"
#import "PTSDatastore.h"

static NSDictionary *sCellTitleMappings;

typedef NS_ENUM(NSInteger, PTSManageDataViewTableSection) {
  PTSManageDataViewTableSectionAssessments = 0,
  PTSManageDataViewTableSectionPreferences = 1,
  PTSManageDataViewTableSectionDeletion = 2,
  PTSManageDataViewTableSectionDataCollection = 3
};

typedef NS_ENUM(NSInteger, PTSManageDataViewTableRow) {
  // Assessments
  PTSManageDataViewTableRowExportAssessments = 0,
  PTSManageDataViewTableRowDeleteAssessments = 1,
  
  // Preferences
  PTSManageDataViewTableRowResetPreferences = 0,
  
  // Data Deletion
  PTSManageDataViewTableRowDeleteData = 0,
  
  // Data Collection
  PTSManageDataViewTableRowAnonymousUsage = 0
};

#pragma mark - Private Interface

@interface PTSManageDataViewController ()

@property(nonatomic, strong) UISwitch *anonymousUsageSwitch;
@property(nonatomic, weak) IBOutlet UITableViewCell *anonymousDataUsageTableCell;

@end

#pragma mark - Implementation

@implementation PTSManageDataViewController

#pragma mark - Class Methods

/**
 *  initalize
 */
+ (void)initialize {
  sCellTitleMappings = @{
                         @(PTSManageDataViewTableSectionAssessments) :
                           @{ @(PTSManageDataViewTableRowExportAssessments) : NSLocalizedString(@"Export Assessment Data", nil),
                              @(PTSManageDataViewTableRowDeleteAssessments): NSLocalizedString(@"Delete Assessment Data", nil) },
                         
                         @(PTSManageDataViewTableSectionPreferences) :
                           @{ @(PTSManageDataViewTableRowResetPreferences): NSLocalizedString(@"Reset Tool Preferences", nil) },
                         
                         @(PTSManageDataViewTableSectionDeletion) :
                           @{ @(PTSManageDataViewTableRowDeleteData): NSLocalizedString(@"Delete All Data", nil) },
                         
                         @(PTSManageDataViewTableSectionDataCollection) :
                           @{ @(PTSManageDataViewTableRowAnonymousUsage): NSLocalizedString(@"Provide Anonymous Usage Data", nil) }
                         };
}

#pragma mark - UIViewController

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
  return 4;
}

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == PTSManageDataViewTableSectionAssessments) {
    return 2;
  }
  
  return 1;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSBasicTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierBasic];
  
  if (indexPath.section == PTSManageDataViewTableSectionDataCollection && indexPath.row == PTSManageDataViewTableRowAnonymousUsage) {
    UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchControl.on = [PTSDatastore sharedDatastore].isAnalyticsTrackingEnabled;
    
    [switchControl addTarget:self action:@selector(handleAnonymousDataSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    cell.accessoryView = switchControl;
    cell.labelTintColor = nil;
  } else {
    cell.accessoryView = nil;
    
    // Hack: Tint the label color to look like a buttons
    UIButton *dummyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cell.labelTintColor = dummyButton.tintColor;
  }
  
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.primaryText = sCellTitleMappings[@(indexPath.section)][@(indexPath.row)];
  
  return cell;
}

/**
 *  tableView:heightForFooterInSection
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (section == PTSManageDataViewTableSectionDataCollection) {
    return UITableViewAutomaticDimension;
  }
  
  return 0;
}

/**
 *  tableView:titleForFooterInSection
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  if (section == PTSManageDataViewTableSectionDataCollection) {
    return NSLocalizedString(@"Help improve this app by automatically sending daily diagnostics and "
                             "anonymous, deidentified usage data. Diagnostic data may include location "
                             "information. Although no one can see your personal data, looking at overall "
                             "trends helps us make better apps.", nil);
  }
  
  return nil;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case PTSManageDataViewTableSectionAssessments: {
      if (indexPath.row == PTSManageDataViewTableRowExportAssessments) {
        [self showExportAssessmentsAlert];
      } else if (indexPath.row == PTSManageDataViewTableRowDeleteAssessments) {
        [self showDeleteAssessmentsAlert];
      }
      
      break;
    }
      
    case PTSManageDataViewTableSectionPreferences: {
      if (indexPath.row == PTSManageDataViewTableRowResetPreferences) {
        [self showResetPreferencesAlert];
      }
      
      break;
    }
      
    case PTSManageDataViewTableSectionDeletion: {
      if (indexPath.row == PTSManageDataViewTableRowDeleteData) {
        [self showDeleteAllUserDataAlert];
      }
      
      break;
    }
      
    case PTSManageDataViewTableSectionDataCollection: {
      if (indexPath.row == PTSManageDataViewTableRowAnonymousUsage) {
        
      }
      
      break;
    }
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

/**
 *  exportAssessments
 */
- (void)exportAssessments {
  NSLog(@"TODO: Manage Data - Export Assessments");
}

/**
 *  showExportAssessmentsAlert
 */
- (void)showExportAssessmentsAlert {
  NSString *title = NSLocalizedString(@"Warning", nil);
  NSString *message = NSLocalizedString(@"To protect your privacy, send this email only to yourself "
                                        "at a secure personal account. Do not send this email to your "
                                        "healthcare provider or to anyone else.",  nil);
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                          [self exportAssessments];
                                                        }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];

  [alertController addAction:defaultAction];
  [alertController addAction:cancelAction];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  deleteAssessments
 */
- (void)deleteAssessments {
  [PTSDatastore sharedDatastore].assessments = nil;
}

/**
 *  showDeleteAssessmentsAlert
 */
- (void)showDeleteAssessmentsAlert {
  NSString *title = NSLocalizedString(@"Warning", nil);
  NSString *message = NSLocalizedString(@"Are you sure you want to delete your assessment history? "
                                        "You won’t be able to compare new assessment results with "
                                        "these earlier results.",  nil);
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil)
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * action) {
                                                          [self deleteAssessments];
                                                        }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
  
  [alertController addAction:defaultAction];
  [alertController addAction:cancelAction];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  resetPreferences
 */
- (void)resetPreferences {
  [[PTSDatastore sharedDatastore] clearToolPreferences];
}

/**
 *  showResetPreferencesAlert
 */
- (void)showResetPreferencesAlert {
  NSString *title = NSLocalizedString(@"Warning", nil);
  NSString *message = NSLocalizedString(@"This will clear all per-tool “thumbs up” and "
                                        "“thumbs down” tool preferences you’ve selected. "
                                        "Are you sure?",  nil);
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reset", nil)
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * action) {
                                                          [self resetPreferences];
                                                        }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
  
  [alertController addAction:defaultAction];
  [alertController addAction:cancelAction];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  deleteAllUserData
 */
- (void)deleteAllUserData {
  [[PTSDatastore sharedDatastore] clearAllUserData];
}

/**
 *  showDeleteAllUserDataAlert
 */
- (void)showDeleteAllUserDataAlert {
  NSString *title = NSLocalizedString(@"Warning", nil);
  NSString *message = NSLocalizedString(@"This will delete all of your data! The app will behave as "
                                        "though it was just installed. Are you sure?",  nil);
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil)
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * action) {
                                                          [self deleteAllUserData];
                                                        }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
  
  [alertController addAction:defaultAction];
  [alertController addAction:cancelAction];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Event Handlers

/**
 *  handleAnonymousDataSwitchValueChanged
 */
- (void)handleAnonymousDataSwitchValueChanged:(id)sender {
  UISwitch *switchControl = (UISwitch *)sender;
  
  [[PTSDatastore sharedDatastore] setAnalyticsTrackingEnabled:switchControl.isOn];
}

@end
