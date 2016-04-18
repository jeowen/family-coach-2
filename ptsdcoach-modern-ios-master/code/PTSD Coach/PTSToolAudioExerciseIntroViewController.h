//
//  PTSToolAudioExerciseIntroViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>
#import "PTSToolViewDelegate.h"

@interface PTSToolAudioExerciseIntroViewController : UIViewController<PTSToolViewDelegate>

// Public Properties
@property(nonatomic, strong) PTSTool *tool;

@end
