//
//  PTSViewControllerCrossfadeAnimator.m
//  PTSD Coach
//

#import "PTSViewControllerCrossfadeAnimator.h"

static const CGFloat kAnimationDuration = 0.33;

@implementation PTSViewControllerCrossfadeAnimator

#pragma mark - UIViewControllerAnimatedTransitioning Methods

/**
 *  transitionDuration
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return kAnimationDuration;
}

/**
 *  animateTransition
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

  UIViewController *incomingController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIViewController *outgoingController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *container = [transitionContext containerView];
  
  incomingController.view.alpha = 0.0f;
  [container addSubview:incomingController.view];
  
  [UIView animateWithDuration:kAnimationDuration animations:^{
    incomingController.view.alpha = 1.0;
  } completion:^(BOOL finished){
    [outgoingController.view removeFromSuperview];
    [transitionContext completeTransition:finished];
  }];
}

@end
