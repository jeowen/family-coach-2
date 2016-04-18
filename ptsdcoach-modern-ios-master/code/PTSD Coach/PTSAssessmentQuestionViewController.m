//
//  PTSAssessmentQuestionViewController.m
//  PTSD Coach
//

#import "PTSAssessmentQuestionViewController.h"
#import "PTSAssessment.h"
#import "PTSAssessmentAnswer.h"
#import "PTSAssessmentFeedbackViewController.h"
#import "PTSAssessmentQuestion.h"
#import "PTSAssessmentSession.h"
#import "PTSBasicTableViewCell.h"
#import "PTSDatastore.h"
#import "PTSSegmentedTextView.h"
#import "NSString+PTSString.h"

static NSString *const PTSSegueIdentifierShowAssessmentFeedback = @"ShowAssessmentFeedbackSegue";

#pragma mark - Private Interface

@interface PTSAssessmentQuestionViewController ()

@property(nonatomic, weak) IBOutlet UIBarButtonItem *nextBarButtonItem;
@property(nonatomic, strong) PTSAssessment *completedAssessment;

@end

#pragma mark - Implementation

@implementation PTSAssessmentQuestionViewController

#pragma mark - Lifecycle

/**
 *  dealloc
 */
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  NSAssert(self.assessmentSession != nil, @"Assessment Session required.");
  
  [super viewDidLoad];

  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  [self.tableView registerClass:[PTSBasicTableViewCell class] forCellReuseIdentifier:PTSTableCellIdentifierBasic];
  
  self.title = [NSString stringWithFormat:NSLocalizedString(@"Question %@ of %@", nil),
                @(self.assessmentSession.currentQuestionIndex + 1),
                @(self.assessmentSession.questions.count)];
  
  if (self.assessmentSession.isOnLastQuestion) {
    self.nextBarButtonItem.title = NSLocalizedString(@"Submit", nil);
  } else {
    self.nextBarButtonItem.title = NSLocalizedString(@"Next", nil);
  }

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(rebuildHeaderView)
                                               name:UIContentSizeCategoryDidChangeNotification
                                             object:nil];
}

/**
 *  viewWillTransitionToSize:withTransitionCoordinator
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [self rebuildHeaderView];
}

/**
 *  viewDidLayoutSubviews
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self rebuildHeaderView];
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierShowAssessmentFeedback]) {
    NSAssert(self.completedAssessment != nil, @"Assessment feedback segue requires completed assessment.");
    
    PTSAssessmentFeedbackViewController *feedbackViewController = (PTSAssessmentFeedbackViewController *)segue.destinationViewController;
    feedbackViewController.assessment = self.completedAssessment;
  }
}

#pragma mark - IBActions

/**
 *  handleNextButtonTapped
 */
- (IBAction)handleNextButtonTapped:(id)sender {
  if (self.assessmentSession.isOnLastQuestion) {
    self.completedAssessment = [[PTSAssessment alloc] initWithAssessmentSession:self.assessmentSession];
    
    PTSDatastore *datastore = [PTSDatastore sharedDatastore];
    datastore.assessments = [@[self.completedAssessment] arrayByAddingObjectsFromArray:datastore.assessments];

    [self performSegueWithIdentifier:PTSSegueIdentifierShowAssessmentFeedback sender:nil];
  } else {
    // Advance to the next question
    self.assessmentSession.currentQuestionIndex = self.assessmentSession.currentQuestionIndex + 1;

    PTSAssessmentQuestionViewController *nextQuestionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PTSAssessmentQuestionViewControllerIdentifier"];
    nextQuestionViewController.assessmentSession = self.assessmentSession;
    
    [self.navigationController pushViewController:nextQuestionViewController animated:YES];
  }
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
  return self.assessmentSession.currentQuestion.availableAnswers.count;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSAssessmentAnswer *answer = self.assessmentSession.currentQuestion.availableAnswers[indexPath.row];
  PTSBasicTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierBasic];
  cell.accessibilityTraits |= UIAccessibilityTraitButton;
  cell.primaryText = answer.text;
  
  if (self.assessmentSession.currentQuestion.selectedAnswer == answer) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
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
  
  PTSAssessmentAnswer *selectedAnswer = self.assessmentSession.currentQuestion.availableAnswers[indexPath.row];
  self.assessmentSession.currentQuestion.selectedAnswer = selectedAnswer;
  self.nextBarButtonItem.enabled = YES;
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

/**
 *  rebuildHeaderView
 *
 *  UITableView cannot properly handle a dynamically sized header view. To help it out,
 *  we just apply a little brute-force love and recreate the header view every time
 *  we need to update it. Seems to work...
 *
 */
- (void)rebuildHeaderView {
  PTSSegmentedTextView *segmentedTextView = [[PTSSegmentedTextView alloc] initWithFrame:CGRectZero];
  segmentedTextView.text = self.assessmentSession.currentQuestion.text;
  segmentedTextView.translatesAutoresizingMaskIntoConstraints = NO;
  segmentedTextView.useScrollView = NO;
  
  UIView *headerViewWrapper = [[UIView alloc] initWithFrame:CGRectZero];
  headerViewWrapper.backgroundColor = [UIColor whiteColor];
  headerViewWrapper.preservesSuperviewLayoutMargins = YES;
  headerViewWrapper.translatesAutoresizingMaskIntoConstraints = NO;
  
  [headerViewWrapper addSubview:segmentedTextView];
  
  NSDictionary *views = @{ @"header" : segmentedTextView };
  [headerViewWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[header]-|" options:0 metrics:nil views:views]];
  [headerViewWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[header]-|" options:0 metrics:nil views:views]];

  // This is the somewhat bizarre gymnastics routine I think we need to perform in order to make
  // auto-layout do what we want so that when we calculate the size of the headerViewWrapper, the
  // correct margins are taken into account. Since UIViewController overrides the layout margins
  // of its root view, we need to temporarily add the headerViewWrapper to the root view so that
  // when we request the fitting size below, the correct layout margins are present. /shrug
  [self.view addSubview:headerViewWrapper];
  [headerViewWrapper.leftAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leftAnchor].active = YES;
  [headerViewWrapper.rightAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.rightAnchor].active = YES;
  
  [headerViewWrapper setNeedsLayout];
  [headerViewWrapper layoutIfNeeded];

  // UITableView seems to want its header view to use resizing masks and not constraints. Fine.
  headerViewWrapper.translatesAutoresizingMaskIntoConstraints = YES;

  // Determine auto-layout's appropriate fitting size and then force the header view to be that height.
  CGRect frame = headerViewWrapper.frame;
  frame.size.height = ceil([headerViewWrapper systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
  headerViewWrapper.frame = frame;
  
  // Move the wrapper view from the root view into the table view header and then cross our fingers.
  [headerViewWrapper removeFromSuperview];
  self.tableView.tableHeaderView = headerViewWrapper;
}

@end
