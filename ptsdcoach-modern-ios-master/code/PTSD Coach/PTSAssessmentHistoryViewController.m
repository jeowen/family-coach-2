//
//  PTSAssessmentHistoryViewController.m
//  PTSD Coach
//

#import "PTSAssessmentHistoryViewController.h"

typedef NS_ENUM(NSInteger, PTSAssessmentHistorySegmentedIndex) {
  PTSAssessmentHistorySegmentedIndexGraph = 0,
  PTSAssessmentHistorySegmentedIndexDetails = 1
};

#pragma mark - Private Interface

@interface PTSAssessmentHistoryViewController ()

@property(nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, weak) IBOutlet UIView *graphContainerView;
@property(nonatomic, weak) IBOutlet UIView *assessmentsContainerView;

@end

#pragma mark - Implementation

@implementation PTSAssessmentHistoryViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  self.segmentedControl.selectedSegmentIndex = PTSAssessmentHistorySegmentedIndexGraph;
  self.graphContainerView.hidden = NO;
  self.assessmentsContainerView.hidden = YES;
  
//  [self.navigationController.navigationBar setTranslucent:NO];
//  [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"Transparent Navigation Bar"]];
//  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Transparent Navigation Bar"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - IBActions

/**
 *  handleSegmentedControlValueChanged
 */
- (IBAction)handleSegmentedControlValueChanged:(id)sender {
  UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
  
  if (segmentedControl.selectedSegmentIndex == PTSAssessmentHistorySegmentedIndexGraph) {
    self.graphContainerView.hidden = NO;
    self.assessmentsContainerView.hidden = YES;
  } else if (segmentedControl.selectedSegmentIndex == PTSAssessmentHistorySegmentedIndexDetails) {
    self.graphContainerView.hidden = YES;
    self.assessmentsContainerView.hidden = NO;
  }
}

@end
