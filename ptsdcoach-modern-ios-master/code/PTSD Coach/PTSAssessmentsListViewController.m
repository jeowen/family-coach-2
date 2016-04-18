//
//  PTSAssessmentsListViewController.m
//  PTSD Coach
//

#import "PTSAssessmentsListViewController.h"
#import "PTSAssessment.h"
#import "PTSAssessmentTableViewCell.h"
#import "PTSDatastore.h"

#pragma mark - Private Interface

@interface PTSAssessmentsListViewController()

@property(nonatomic, strong) NSArray *assessments;

@end

#pragma mark - Implementation

@implementation PTSAssessmentsListViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  [self.tableView registerClass:[PTSAssessmentTableViewCell class] forCellReuseIdentifier:PTSTableCellIdentifierAssessment];
}

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // Always ensure that we have the most recent list of assessments
  self.assessments = nil;
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
  return self.assessments.count;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSAssessment *assessment = self.assessments[indexPath.row];
  PTSAssessmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierAssessment forIndexPath:indexPath];
  [cell prepareWithAssessment:assessment];

  return cell;
}

#pragma mark - Private Properties

/**
 *  assessments
 */
- (NSArray *)assessments {
  if (!_assessments) {
    // Sort assessments from newest to oldest
    NSArray *unorderedAssessments = [PTSDatastore sharedDatastore].fakeAssessments;
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    _assessments = [unorderedAssessments sortedArrayUsingDescriptors:@[descriptor]];
  }
  
  return _assessments;
}

@end
