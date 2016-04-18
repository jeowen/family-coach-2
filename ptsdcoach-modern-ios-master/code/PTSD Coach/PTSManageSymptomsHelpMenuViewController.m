//
//  PTSManageSymptomsHelpMenuViewController.m
//  PTSD Coach
//

#import "PTSManageSymptomsHelpMenuViewController.h"
#import "PTSBasicTableViewCell.h"
#import "PTSSegmentedTextViewController.h"

static NSString *const PTSSegueIndentifierShowSegmentedTextView = @"ShowSegmentedTextViewSegue";
static NSDictionary *sTableRowToTitleMappings;
static NSDictionary *sTableRowToFilenameMappings;

typedef NS_ENUM(NSInteger, PTSManageSymptomsHelpMenuTableRow) {
  PTSManageSymptomsHelpMenuTableRowPTSDSymptoms = 0,
  PTSManageSymptomsHelpMenuTableRowChangePerspective,
  PTSManageSymptomsHelpMenuTableRowConnectOthers,
  PTSManageSymptomsHelpMenuTableRowDeepBreathing,
  PTSManageSymptomsHelpMenuTableRowGrounding,
  PTSManageSymptomsHelpMenuTableRowFallingAsleep,
  PTSManageSymptomsHelpMenuTableRowInspiringQuotes,
  PTSManageSymptomsHelpMenuTableRowLeisureActivities,
  PTSManageSymptomsHelpMenuTableRowMuscleRelaxation,
  PTSManageSymptomsHelpMenuTableRowPositiveImagery,
  PTSManageSymptomsHelpMenuTableRowRID,
  PTSManageSymptomsHelpMenuTableRowThoughtStopping,
  PTSManageSymptomsHelpMenuTableRowTimeOut,
  
  // Convience ENUM for row count.
  PTSManageSymptomsHelpMenuTableRowCount
};

#pragma mark - Private Interface

@interface PTSManageSymptomsHelpMenuViewController ()

@property(nonatomic, strong) NSString *segmentedTextViewFilename;

@end

#pragma mark - Implementation

@implementation PTSManageSymptomsHelpMenuViewController

#pragma mark - Class Methods

/**
 *  initialize
 */
+ (void)initialize {
  sTableRowToTitleMappings = @{ @(PTSManageSymptomsHelpMenuTableRowPTSDSymptoms) : NSLocalizedString(@"PTSD Symptoms", nil),
                                @(PTSManageSymptomsHelpMenuTableRowChangePerspective) : NSLocalizedString(@"Change Your Perspective", nil),
                                @(PTSManageSymptomsHelpMenuTableRowConnectOthers) : NSLocalizedString(@"Connect with Others", nil),
                                @(PTSManageSymptomsHelpMenuTableRowDeepBreathing) : NSLocalizedString(@"Deep Breathing", nil),
                                @(PTSManageSymptomsHelpMenuTableRowGrounding) : NSLocalizedString(@"Grounding", nil),
                                @(PTSManageSymptomsHelpMenuTableRowFallingAsleep) : NSLocalizedString(@"Help Falling Asleep", nil),
                                @(PTSManageSymptomsHelpMenuTableRowInspiringQuotes) : NSLocalizedString(@"Inspiring Quotes", nil),
                                @(PTSManageSymptomsHelpMenuTableRowLeisureActivities) : NSLocalizedString(@"Leisure Activities", nil),
                                @(PTSManageSymptomsHelpMenuTableRowMuscleRelaxation) : NSLocalizedString(@"Muscle Relaxation", nil),
                                @(PTSManageSymptomsHelpMenuTableRowPositiveImagery) : NSLocalizedString(@"Positive Imagery", nil),
                                @(PTSManageSymptomsHelpMenuTableRowThoughtStopping) : NSLocalizedString(@"RID", nil),
                                @(PTSManageSymptomsHelpMenuTableRowRID) : NSLocalizedString(@"Thought Stopping", nil),
                                @(PTSManageSymptomsHelpMenuTableRowTimeOut) : NSLocalizedString(@"Time Out", nil) };

  sTableRowToFilenameMappings = @{ @(PTSManageSymptomsHelpMenuTableRowPTSDSymptoms) : @"Manage Symptoms Help - PTSD Symptoms.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowChangePerspective) : @"Manage Symptoms Help - Change Your Perspective.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowConnectOthers) : @"Manage Symptoms Help - Connect With Others.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowDeepBreathing) : @"Manage Symptoms Help - Deep Breathing.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowGrounding) : @"Manage Symptoms Help - Grounding.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowFallingAsleep) : @"Manage Symptoms Help - Help Falling Asleep.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowInspiringQuotes) : @"Manage Symptoms Help - Inspiring Quotes.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowLeisureActivities) : @"Manage Symptoms Help - Leisure Activities.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowMuscleRelaxation) : @"Manage Symptoms Help - Muscle Relaxation.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowPositiveImagery) : @"Manage Symptoms Help - Positive Imagery.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowThoughtStopping) : @"Manage Symptoms Help - Thought Stopping.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowRID) : @"Manage Symptoms Help - RID.rtf",
                                   @(PTSManageSymptomsHelpMenuTableRowTimeOut) : @"Manage Symptoms Help - Time Out.rtf" };
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

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIndentifierShowSegmentedTextView]) {
    NSAssert(self.segmentedTextViewFilename != nil, @"Missing filename when attempting to show rich text viewer.");
    NSAssert([segue.destinationViewController isKindOfClass:[PTSSegmentedTextViewController class]], @"Expected segmented text view controller in segue.");
    
    PTSSegmentedTextViewController *segmentedTextViewController = (PTSSegmentedTextViewController *)segue.destinationViewController;
    segmentedTextViewController.filename = self.segmentedTextViewFilename;
  }
}

#pragma mark - IBActions

/**
 *  dismissHelpMenu
 */
- (IBAction)dismissHelpMenu:(id)sender {
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
  return PTSManageSymptomsHelpMenuTableRowCount;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSBasicTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierBasic];
  cell.primaryText = sTableRowToTitleMappings[@(indexPath.row)];

  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.segmentedTextViewFilename = sTableRowToFilenameMappings[@(indexPath.row)];
  [self performSegueWithIdentifier:PTSSegueIndentifierShowSegmentedTextView sender:nil];
}

@end
