//
//  PTSToolDeepBreathingIntroViewController.m
//  PTSD Coach
//

#import "PTSToolDeepBreathingIntroViewController.h"

#pragma mark - Implementation

@implementation PTSToolDeepBreathingIntroViewController

#pragma mark - UIViewController Methods

/**
 *  prepareForSegue:sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Manually set the tool because the therapy session did not instantiate the destination view controller.
  if ([segue.destinationViewController respondsToSelector:@selector(setTool:)]) {
    [segue.destinationViewController performSelector:@selector(setTool:) withObject:self.tool];
  }
}

@end
