//
//  PTSHelpViewerViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTSHelpViewerSubject) {
  PTSHelpViewerSubjectTrackSymptoms = 1,
  PTSHelpViewerSubjectDistressMeter
  
};

@interface PTSHelpViewerViewController : UIViewController

// Public Properties
@property(nonatomic, assign) PTSHelpViewerSubject subject;

@end
