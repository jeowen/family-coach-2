//
//  PTSAssessmentQuestionViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

@class PTSAssessmentSession;

@interface PTSAssessmentQuestionViewController : UITableViewController

// Public Properties
@property(nonatomic, strong) PTSAssessmentSession *assessmentSession;

@end
