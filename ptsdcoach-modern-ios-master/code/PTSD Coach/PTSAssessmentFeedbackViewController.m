//
//  PTSAssessmentFeedbackViewController.m
//  PTSD Coach
//

#import "PTSAssessmentFeedbackViewController.h"
#import "PTSAssessment.h"
#import "PTSContentLoader.h"
#import "PTSDatastore.h"
#import "PTSSegmentedTextView.h"

typedef NS_ENUM(NSInteger, PTSAssessmentScoreVariation) {
  PTSAssessmentScoreVariationInitialAssessment = 0,
  PTSAssessmentScoreVariationNoChange,
  PTSAssessmentScoreVariationIncreased,
  PTSAssessmentScoreVariationDecreased
};

#pragma mark - Private Interface

@interface PTSAssessmentFeedbackViewController ()

@property(nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property(nonatomic, weak) IBOutlet PTSSegmentedTextView *feedbackTextView;

@end

#pragma mark - Implementation

@implementation PTSAssessmentFeedbackViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  NSAssert(self.assessment != nil, @"Assessment feedback controller requires an assessment.");

  [super viewDidLoad];
  [self configureFeedback];
}

#pragma mark - Private Methods

/**
 *  configureFeedback
 */
- (void)configureFeedback {
  NSString *feedbackFilename;
  NSInteger assessmentScore = self.assessment.score;
  PTSAssessmentScoreVariation scoreVariation = PTSAssessmentScoreVariationInitialAssessment;
  
  if (assessmentScore == 0) {

    if (scoreVariation == PTSAssessmentScoreVariationInitialAssessment) {
      feedbackFilename = @"Feedback - Score 0 First Time.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationNoChange) {
      feedbackFilename = @"Feedback - Score 0 No Change.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationIncreased) {
      NSAssert(NO, @"Invalid assessment score variation");
    } else if (scoreVariation == PTSAssessmentScoreVariationDecreased) {
      feedbackFilename = @"Feedback - Score 0 Decreased.rtf";
    }
    
  } else if (assessmentScore >= 1 && assessmentScore <= 15) {
    
    if (scoreVariation == PTSAssessmentScoreVariationInitialAssessment) {
      feedbackFilename = @"Feedback - Score 1-15 First Time.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationNoChange) {
      feedbackFilename = @"Feedback - Score 1-15 No Change.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationIncreased) {
      feedbackFilename = @"Feedback - Score 1-15 Increased.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationDecreased) {
      feedbackFilename = @"Feedback - Score 1-15 Decreased.rtf";
    }

  } else if (assessmentScore >= 16 && assessmentScore <= 32) {
    
    if (scoreVariation == PTSAssessmentScoreVariationInitialAssessment) {
      feedbackFilename = @"Feedback - Score 16-32 First Time.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationNoChange) {
      feedbackFilename = @"Feedback - Score 16-32 No Change.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationIncreased) {
      feedbackFilename = @"Feedback - Score 16-32 Increased.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationDecreased) {
      feedbackFilename = @"Feedback - Score 16-32 Decreased.rtf";
    }

  } else if (assessmentScore >= 33 && assessmentScore <= 80) {
    
    if (scoreVariation == PTSAssessmentScoreVariationInitialAssessment) {
      feedbackFilename = @"Feedback - Score 33-80 First Time.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationNoChange) {
      feedbackFilename = @"Feedback - Score 33-80 No Change.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationIncreased) {
      feedbackFilename = @"Feedback - Score 33-80 Increased.rtf";
    } else if (scoreVariation == PTSAssessmentScoreVariationDecreased) {
      feedbackFilename = @"Feedback - Score 33-80 Decreased.rtf";
    }

  }
  
  NSAssert(feedbackFilename != nil, @"Missing feedback content for assessment.");
  
  PTSContentLoader *contentLoader = [PTSContentLoader contentLoaderWithFilename:feedbackFilename];
  
  self.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Total Score: %@", nil), @(self.assessment.score)];
  self.feedbackTextView.text = contentLoader.plainString;
}

@end
