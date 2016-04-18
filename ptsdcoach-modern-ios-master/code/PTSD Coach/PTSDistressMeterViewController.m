//
//  PTSDistressMeterViewController.m
//  PTSD Coach
//

#import "PTSDistressMeterViewController.h"
#import "PTSDistressMeterHighDistressViewController.h"
#import "PTSDistressMeterOutcomeViewController.h"
#import "PTSHelpViewerViewController.h"
#import "PTSTherapySession.h"

static NSString *const PTSSegueIdentifierShowDistressHelp = @"ShowDistressHelpSegue";
static NSString *const PTSSegueIdentifierShowHighDistress = @"ShowHighDistressSegue";
static NSString *const PTSSegueIdentifierShowDistressOutcome = @"ShowDistressOutcomeSegue";

#pragma mark - Private Interface

@interface PTSDistressMeterViewController()

@property(nonatomic, weak) IBOutlet UISlider *slider;
@property(nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property(nonatomic, weak) IBOutlet UILabel *instructionsLabel;
@property(nonatomic, weak) IBOutlet UIButton *nextButton;
@property(nonatomic, weak) IBOutlet UIButton *skipButton;

@end

#pragma mark - Implementation

@implementation PTSDistressMeterViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.nextButton.enabled = NO;
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierShowDistressHelp]) {
    UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
    PTSHelpViewerViewController *helpViewController = (PTSHelpViewerViewController *)navigationController.topViewController;
    helpViewController.subject = PTSHelpViewerSubjectDistressMeter;
  } else if ([segue.identifier isEqual:PTSSegueIdentifierShowHighDistress]) {
    PTSDistressMeterHighDistressViewController *distressViewController = (PTSDistressMeterHighDistressViewController *)segue.destinationViewController;
    distressViewController.therapySession = self.therapySession;
  } else if ([segue.identifier isEqual:PTSSegueIdentifierShowDistressOutcome]) {
    PTSDistressMeterOutcomeViewController *outcomeViewController = (PTSDistressMeterOutcomeViewController *)segue.destinationViewController;
    outcomeViewController.therapySession = self.therapySession;
  }
}

#pragma mark - PTSToolViewDelegate Methods

/**
 *  wantsToolbarHidden
 */
- (BOOL)wantsToolbarHidden {
  return YES;
}

#pragma mark - IBActions

/**
 *  unwindToRerateDistress
 */
- (IBAction)unwindToRerateDistress:(UIStoryboardSegue *)segue {
  self.skipButton.hidden = YES;
  self.nextButton.enabled = NO;
  self.slider.value = self.slider.minimumValue + ((self.slider.maximumValue - self.slider.minimumValue) / 2);
  self.ratingLabel.text = NSLocalizedString(@"?", nil);
  self.instructionsLabel.text = NSLocalizedString(@"Rate your distress again on a scale of 0 to 10. "
                                                  "Tracking your distress will allow you to learn which "
                                                  "tools help you the most.", nil);
}

/**
 *  handleSliderValueChanged
 */
- (IBAction)handleSliderValueChanged:(id)sender {
  self.ratingLabel.text = [NSString stringWithFormat:@"%.0f", floor(self.slider.value)];
  self.nextButton.enabled = YES;
}

/**
 *  handleNextButtonPressed
 */
- (IBAction)handleNextButtonPressed:(id)sender {
  // Show High Distress if the user ever reports a level of 9 or 10.
  if (self.slider.value >= 9.0 && self.slider.value <= 10.0) {
    [self performSegueWithIdentifier:PTSSegueIdentifierShowHighDistress sender:nil];
    
    return;
  }

  BOOL isFirstTimeEvaluatingDistressLevel = !self.therapySession.hasRecordedInitialDistressLevel;
  self.therapySession.distressLevel = floor(self.slider.value);

  // If this is the first time we've recorded a distress level, then go straight to the tool.
  if (isFirstTimeEvaluatingDistressLevel) {
    [self showViewControllerForTherapySessionTool];
  } else {
    [self performSegueWithIdentifier:PTSSegueIdentifierShowDistressOutcome sender:nil];
  }
}

/**
 *  handleSkipButtonPressed
 */
- (IBAction)handleSkipButtonPressed:(id)sender {
  [self showViewControllerForTherapySessionTool];
}

#pragma mark - Private Methods

/**
 *  showViewControllerForTherapySessionTool
 */
- (void)showViewControllerForTherapySessionTool {
  UIViewController *viewController = [self.therapySession instantiateViewControllerForCurrentTool];
  [self.navigationController pushViewController:viewController animated:YES];
}

@end
