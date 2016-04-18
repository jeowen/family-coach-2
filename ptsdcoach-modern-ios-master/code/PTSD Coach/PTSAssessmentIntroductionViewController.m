//
//  PTSAssessmentIntroductionViewController.m
//  PTSD Coach
//

#import "PTSAssessmentIntroductionViewController.h"
#import "PTSAssessmentSession.h"
#import "PTSAssessmentQuestionViewController.h"
#import "PTSHelpViewerViewController.h"

#pragma mark - Private Interface

@interface PTSAssessmentIntroductionViewController ()

@property(nonatomic, strong) PTSAssessmentSession *assessmentSession;

@end

#pragma mark - Implementation

@implementation PTSAssessmentIntroductionViewController

#pragma mark - UIViewController Methods

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"ShowAssessmentQuestionSegue"]) {
    PTSAssessmentQuestionViewController *questionViewController = (PTSAssessmentQuestionViewController *)segue.destinationViewController;
    questionViewController.assessmentSession = self.assessmentSession;
  } else if ([segue.identifier isEqual:@"ShowTrackSymptomsHelpSegue"]) {
    UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
    PTSHelpViewerViewController *helpViewController = (PTSHelpViewerViewController *)navigationController.topViewController;
    helpViewController.subject = PTSHelpViewerSubjectTrackSymptoms;
  }
}

#pragma mark - Private Properties

/**
 *  assessmentSession
 */
- (PTSAssessmentSession *)assessmentSession {
  if (!_assessmentSession) {
    _assessmentSession = [[PTSAssessmentSession alloc] init];
  }
  
  return _assessmentSession;
}

@end
