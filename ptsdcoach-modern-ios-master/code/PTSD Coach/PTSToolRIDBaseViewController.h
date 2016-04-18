//
//  PTSToolRIDBaseViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>
#import "PTSToolViewDelegate.h"

@class PTSRIDSession;

@interface PTSToolRIDBaseViewController : UIViewController<PTSToolViewDelegate>

// Public Properties
@property(nonatomic, strong) PTSTool *tool;
@property(nonatomic, strong) PTSRIDSession *RIDSession;

@end
