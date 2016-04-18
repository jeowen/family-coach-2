//
//  PTSTrackSymptomsRootViewController.m
//  PTSD Coach
//

#import "PTSTrackSymptomsRootViewController.h"
#import "PTSBasicTableViewCell.h"
#import "PTSDatastore.h"
#import "PTSAssessment.h"
#import "PTSHelpViewerViewController.h"

static NSDictionary *sTableRowToTitleMappings;

typedef NS_ENUM(NSInteger, PTSTrackSymptomsTableRow) {
  PTSTrackSymptomsTableRowTakeAssessment = 0,
  PTSTrackSymptomsTableRowShowHistory,
  PTSTrackSymptomsTableRowScheduleAssessment
};

#pragma mark - Implementation

@implementation PTSTrackSymptomsRootViewController

#pragma mark - Class Methods

/**
 *  initialize
 */
+ (void)initialize {
  sTableRowToTitleMappings = @{ @(PTSTrackSymptomsTableRowTakeAssessment) : NSLocalizedString(@"Take Assessment", nil),
                                @(PTSTrackSymptomsTableRowShowHistory) : NSLocalizedString(@"Assessment History", nil),
                                @(PTSTrackSymptomsTableRowScheduleAssessment) : NSLocalizedString(@"Schedule Assessment", nil) };
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
  return 3;
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
  NSString *segueIdentifier;
  
  switch (indexPath.row) {
    case PTSTrackSymptomsTableRowTakeAssessment: {
      NSArray *assessments = [PTSDatastore sharedDatastore].assessments;
      PTSAssessment *lastAssessment = [assessments lastObject];
      NSDate *lastAssessmentDate = lastAssessment.date;
      BOOL isTooEarly = NO;
      
      if (isTooEarly) {
        segueIdentifier = @"ShowAssessmentTooEarlySegue";
      } else {
        segueIdentifier = @"ShowStartAssessmentSegue";
      }

      break;
    }

    case PTSTrackSymptomsTableRowShowHistory: {
      NSArray *assessments = [PTSDatastore sharedDatastore].fakeAssessments;
      if (assessments.count == 0) {
        segueIdentifier = @"ShowNoHistorySegue";
      } else {
        segueIdentifier = @"ShowAssessmentHistorySegue";
      }
      
      break;
    }

    case PTSTrackSymptomsTableRowScheduleAssessment: {
      segueIdentifier = @"ShowRemindersSegue";
      break;
    }
  }
  
  if (segueIdentifier) {
    [self performSegueWithIdentifier:segueIdentifier sender:nil];
  }
}

#pragma mark - Navigation

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"ShowTrackSymptomsHelpSegue"]) {
    UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
    PTSHelpViewerViewController *helpViewController = (PTSHelpViewerViewController *)navigationController.topViewController;
    helpViewController.subject = PTSHelpViewerSubjectTrackSymptoms;
  } 
}

/**
 *  unwindToTrackSymptomsRootViewController
 */
- (IBAction)unwindToTrackSymptomsRootViewController:(UIStoryboardSegue*)sender {
  // Intentionally left blank.
}

@end
