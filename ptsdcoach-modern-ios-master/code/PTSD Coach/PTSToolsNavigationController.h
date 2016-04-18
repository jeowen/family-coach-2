//
//  PTSToolsNavigationController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

@class PTSTherapySession;

@interface PTSToolsNavigationController : UINavigationController

// Public Properties
@property(nonatomic, strong) PTSTherapySession *therapySession;

@end
