//
//  PTSToolsNavigationController.m
//  PTSD Coach
//

#import "PTSToolsNavigationController.h"
#import "PTSToolViewDelegate.h"
#import "PTSTherapySession.h"
#import "PTSTool.h"
#import "PTSViewControllerCrossfadeAnimator.h"

const NSInteger PTSToolbarButtonItemTagThumbsDown = 5000;
const NSInteger PTSToolbarButtonItemTagThumbsUp = 5001;

#pragma mark - Private Interface

@interface PTSToolsNavigationController()<UINavigationControllerDelegate>

@end

#pragma mark - Implementation

@implementation PTSToolsNavigationController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Be our own delegate...
  self.delegate = self;
}

#pragma mark - UINavigationControllerDelegate Methods

/**
 *  navigationController:willShowViewController:animated
 */
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  
  if ([viewController conformsToProtocol:@protocol(PTSToolViewDelegate)]) {
    
    id<PTSToolViewDelegate> toolViewController = (id<PTSToolViewDelegate>)viewController;
    
    // Set the title if one hasn't been explicitly set
    if (!viewController.title && !viewController.navigationItem.title) {
      viewController.title = self.therapySession.currentTool.title;
    }
    
    // If a custom navigation item has not been set for the left bar button item, then configure one.
    if (!viewController.navigationItem.leftBarButtonItem) {
      
      // Display a "Done" button in the left navigation bar item to unwind back to the re-rate distress tool.
      BOOL shouldShowUnwindToRerateDistressButton = YES;
      
      if ([toolViewController respondsToSelector:@selector(wantsUnwindToRerateDistressButton)]) {
        shouldShowUnwindToRerateDistressButton = [toolViewController wantsUnwindToRerateDistressButton];
      }
      
      if (shouldShowUnwindToRerateDistressButton) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                        target:self
                                                                                                        action:@selector(handleUnwindToRerateDistressButton:)];
      }
      
      // Display a "Close" button in the left navigating bar item to dismiss the tool navigation controller.
      BOOL shouldShowDismissButton = NO;
      
      if ([toolViewController respondsToSelector:@selector(wantsDismissButton)]) {
        shouldShowDismissButton = [toolViewController wantsDismissButton];
      }
      
      if (shouldShowDismissButton) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                                           style:UIBarButtonItemStyleDone
                                                                                          target:self
                                                                                          action:@selector(handleDismissButtonPressed:)];
      }
    }
    
    // Toggle toolbar visibility
    BOOL toolbarHidden = NO;
    
    if ([toolViewController respondsToSelector:@selector(wantsToolbarHidden)]) {
      toolbarHidden = [toolViewController wantsToolbarHidden];
    }
    
    [navigationController setToolbarHidden:toolbarHidden animated:YES];
    
    // Only need to configure the toolbar buttons if the toolbar is visible.
    if (!toolbarHidden) {
      // Set the appropriate toolbar items.
      NSMutableArray *mutableToolbarItems = [[NSMutableArray alloc] init];
      
      UIBarButtonItem *thumbsUpButton = [[UIBarButtonItem alloc] initWithTitle:@"T-Up" style:UIBarButtonItemStylePlain target:self action:@selector(handleThumbsUpButtonPressed:)];
      UIBarButtonItem *thumbsDownButton = [[UIBarButtonItem alloc] initWithTitle:@"T-Down" style:UIBarButtonItemStylePlain target:self action:@selector(handleThumbsDownButtonPressed:)];
      
      thumbsUpButton.tag = PTSToolbarButtonItemTagThumbsUp;
      thumbsDownButton.tag = PTSToolbarButtonItemTagThumbsDown;
      
      // TODO: Toggle selected state for thumbs-up and thumbs-down.
      PTSTool *tool = self.therapySession.currentTool;
      if (tool.likeability == PTSToolLikeabilityNegative) {
        thumbsDownButton.title = @"T-Down *";
      } else if (tool.likeability == PTSToolLikeabilityPositive) {
        thumbsUpButton.title = @"T-Up *";
      }
      
      // Thumbs-Up / Thumbs-Down
      [mutableToolbarItems addObject:thumbsDownButton];
      [mutableToolbarItems addObject:thumbsUpButton];
      
      // Closed Captions
      if ([toolViewController respondsToSelector:@selector(wantsClosedCaptioningButtonInToolbar)]) {
        UIBarButtonItem *closedCaptioningButton = [[UIBarButtonItem alloc] initWithTitle:@"CC" style:UIBarButtonItemStylePlain target:self action:@selector(handleClosedCaptioningButtonPressed:)];
        [mutableToolbarItems addObject:closedCaptioningButton];
      }
      
      // Refresh Tool
      if ([toolViewController respondsToSelector:@selector(wantsToolRefreshButtonInToolbar)]) {
        UIBarButtonItem *refreshToolButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(handleRefreshButtonPressed:)];
        [mutableToolbarItems addObject:refreshToolButton];
      }
      
      // Load New Tool
      if (self.therapySession.context == PTSTherapySessionContextSymptom) {
        UIBarButtonItem *loadNewToolButton = [[UIBarButtonItem alloc] initWithTitle:@"New Tool" style:UIBarButtonItemStylePlain target:self action:@selector(handleLoadNewToolButtonPressed:)];
        [mutableToolbarItems addObject:loadNewToolButton];
      }
      
      // Inject flexibile bar button items between each toolbar item.
      NSMutableArray *mutableBarButtonItems = [[NSMutableArray alloc] init];
      [mutableBarButtonItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
      
      for (UIBarButtonItem *barButtonItem in mutableToolbarItems) {
        [mutableBarButtonItems addObject:barButtonItem];
        [mutableBarButtonItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
      }
      
      viewController.toolbarItems = [mutableBarButtonItems copy];
    }
  }
}

/**
 *  navigationController:animationControllerForOperation:fromViewController:toViewController
 */
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromViewController
                                                  toViewController:(UIViewController *)toViewController {
  
  if ([toViewController respondsToSelector:@selector(wantsFadeTransition)]) {
    return [[PTSViewControllerCrossfadeAnimator alloc] init];
  }
  
  return nil;
}

#pragma mark - Action Handlers

/**
 *  handleThumbsDownButtonPressed
 */
- (void)handleThumbsDownButtonPressed:(id)sender {
  if (self.therapySession.currentTool.likeability == PTSToolLikeabilityNegative) {
    self.therapySession.currentTool.likeability = PTSToolLikeabilityNeutral;
  } else {
    self.therapySession.currentTool.likeability = PTSToolLikeabilityNegative;
  }
  
  [self updateLikeabilityStatusOfToolbarButtonItems];
}

/**
 *  handleThumbsUpButtonPressed
 */
- (void)handleThumbsUpButtonPressed:(id)sender {
  if (self.therapySession.currentTool.likeability == PTSToolLikeabilityPositive) {
    self.therapySession.currentTool.likeability = PTSToolLikeabilityNeutral;
  } else {
    self.therapySession.currentTool.likeability = PTSToolLikeabilityPositive;
  }
  
  [self updateLikeabilityStatusOfToolbarButtonItems];
}

/**
 *  handleClosedCaptioningButtonPressed
 */
- (void)handleClosedCaptioningButtonPressed:(id)sender {
  
}

/**
 *  handleRefreshButtonPressed
 */
- (void)handleRefreshButtonPressed:(id)sender {
  UIViewController *viewController = self.topViewController;
  
  if ([viewController conformsToProtocol:@protocol(PTSToolViewDelegate)]) {
    if ([viewController respondsToSelector:@selector(refreshToolIfPossible)]) {
      [(id<PTSToolViewDelegate>)viewController refreshToolIfPossible];
    }
  }
}

/**
 *  handleLoadNewToolButtonPressed
 */
- (void)handleLoadNewToolButtonPressed:(id)sender {
  [self.therapySession prescribeNewTool];
  
  UIViewController *viewController = [self.therapySession instantiateViewControllerForCurrentTool];
  [self popViewControllerAnimated:NO];
  [self pushViewController:viewController animated:NO];
}

/**
 *  handleUnwindToRerateDistressButton
 */
- (void)handleUnwindToRerateDistressButton:(id)sender {
  if (self.therapySession.hasRecordedInitialDistressLevel) {
    [self performSegueWithIdentifier:@"SegueIdentifierUnwindToRerateDistress" sender:nil];
  } else {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

/**
 *  handleDismissButtonPressed
 */
- (void)handleDismissButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

/**
 *  updateLikeabilityStatusOfToolbarButtonItems
 */
- (void)updateLikeabilityStatusOfToolbarButtonItems {
  for (UIBarButtonItem *barButtonItem in self.toolbar.items) {
    
    // Update appearance of the thumbs-up button.
    if (barButtonItem.tag == PTSToolbarButtonItemTagThumbsUp) {
      if (self.therapySession.currentTool.likeability == PTSToolLikeabilityPositive) {
        barButtonItem.title = @"T-Up *";
      } else {
        barButtonItem.title = @"T-Up";
      }
    }
    
    // Update appearance of the thumbs-down button
    if (barButtonItem.tag == PTSToolbarButtonItemTagThumbsDown) {
      if (self.therapySession.currentTool.likeability == PTSToolLikeabilityNegative) {
        barButtonItem.title = @"T-Down *";
      } else {
        barButtonItem.title = @"T-Down";
      }
    }
  }
}

@end
