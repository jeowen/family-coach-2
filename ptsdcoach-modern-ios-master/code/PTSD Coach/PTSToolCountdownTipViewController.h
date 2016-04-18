//
//  PTSToolCountdownTipViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>
#import "PTSToolViewDelegate.h"

@interface PTSToolCountdownTipViewController : UIViewController<PTSToolViewDelegate>

// Public Properties
@property(nonatomic, strong) PTSTool *tool;

@end
