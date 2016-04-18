//
//  PTSToolRIDBaseViewController.m
//  PTSD Coach
//

#import "PTSToolRIDBaseViewController.h"

#pragma mark - Implementation

@implementation PTSToolRIDBaseViewController

#pragma mark - UIViewController Methods

/**
 *  prepareForSegue:sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Pass on the PTSTool and PTSRIDSession to the destination if supported.
  if ([segue.destinationViewController respondsToSelector:@selector(setTool:)]) {
    [segue.destinationViewController performSelector:@selector(setTool:) withObject:self.tool];
  }
  
  if ([segue.destinationViewController respondsToSelector:@selector(setRIDSession:)]) {
    [segue.destinationViewController performSelector:@selector(setRIDSession:) withObject:self.RIDSession];
  }
}

@end
