//
//  PTSToolSelfGuidedExerciseViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>
#import "PTSToolViewDelegate.h"

@interface PTSToolSelfGuidedExerciseViewController : UIViewController<PTSToolViewDelegate>

// Public Properties
@property(nonatomic, strong) PTSTool *tool;

@end
