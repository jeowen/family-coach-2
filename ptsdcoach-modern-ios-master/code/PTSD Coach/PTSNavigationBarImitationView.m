//
//  PTSNavigationBarImitationView.m
//  PTSD Coach
//

#import "PTSNavigationBarImitationView.h"

@implementation PTSNavigationBarImitationView

#pragma mark - UIView Methods

/**
 *  willMoveToWindow
 */
- (void)willMoveToWindow:(UIWindow *)newWindow {
  // Use the layer shadow to draw a one pixel hairline under this view.
  [self.layer setShadowOffset:CGSizeMake(0, 1.0f / UIScreen.mainScreen.scale)];
  [self.layer setShadowRadius:0];
  
  // UINavigationBar's hairline is adaptive, its properties change with
  // the contents it overlies.  You may need to experiment with these
  // values to best match your content.
  [self.layer setShadowColor:[UIColor blackColor].CGColor];
  [self.layer setShadowOpacity:0.25f];
}

@end
