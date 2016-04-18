//
//  PTSManageSymptomsRootViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

@class PTSSymptom;
@class PTSTool;

@interface PTSManageSymptomsRootViewController : UIViewController

// Public Methods
- (void)beginManagementSessionWithSymptom:(PTSSymptom *)symptom;
- (void)beginManagementSessionWithTool:(PTSTool *)tool;

@end
