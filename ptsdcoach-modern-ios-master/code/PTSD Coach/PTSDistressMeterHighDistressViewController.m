//
//  PTSDistressMeterHighDistressViewController.m
//  PTSD Coach
//

#import "PTSDistressMeterHighDistressViewController.h"
#import "PTSTherapySession.h"

@implementation PTSDistressMeterHighDistressViewController

#pragma mark - PTSToolViewDelegate Methods

/**
 *  wantsToolbarHidden
 */
- (BOOL)wantsToolbarHidden {
  return YES;
}

#pragma mark - IBActions

/**
 *  handleShowToolButtonPressed
 */
- (IBAction)handleShowToolButtonPressed:(id)sender {
  UIViewController *viewController = [self.therapySession instantiateViewControllerForCurrentTool];
  [self.navigationController pushViewController:viewController animated:YES];
}

@end
