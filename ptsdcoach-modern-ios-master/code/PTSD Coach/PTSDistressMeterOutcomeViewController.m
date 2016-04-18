//
//  PTSDistressMeterOutcomeViewController.m
//  PTSD Coach
//

#import "PTSDistressMeterOutcomeViewController.h"
#import "PTSDynamicTypeLabel.h"
#import "PTSTherapySession.h"
#import "PTSTool.h"

#pragma mark - Private Interface

@interface PTSDistressMeterOutcomeViewController()

@property(nonatomic, weak) IBOutlet UIButton *continueSessionWithSameToolButton;
@property(nonatomic, weak) IBOutlet UIButton *continueSessionWithNewToolButton;
@property(nonatomic, weak) IBOutlet UIStackView *stackView;

@end

@implementation PTSDistressMeterOutcomeViewController

#pragma mark - UIViewController Methods

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self prepareViewForDisplay];
}

#pragma mark - IBActions

/**
 *  handleNewToolButtonPressed
 */
- (IBAction)handleNewToolButtonPressed:(id)sender {
  [self.therapySession prescribeNewTool];

  UIViewController *viewController = [self.therapySession instantiateViewControllerForCurrentTool];
  [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  handleRepeatToolButtonPressed
 */
- (IBAction)handleRepeatToolButtonPressed:(id)sender {
  UIViewController *viewController = [self.therapySession instantiateViewControllerForCurrentTool];
  [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - PTSToolViewDelegate Methods

/**
 *  wantsToolbarHidden
 */
- (BOOL)wantsToolbarHidden {
  return YES;
}

#pragma mark - Private Methods

/**
 *  prepareViewForDisplay
 */
- (void)prepareViewForDisplay {
  NSAssert(self.therapySession != nil, @"Distress outcome view requires a therapy session.");
  
  // Remove all previous labels
  NSArray *arrangedViews = self.stackView.arrangedSubviews;
  for (UIView *arrangedView in arrangedViews) {
    if ([arrangedView isKindOfClass:[UILabel class]]) {
      [self.stackView removeArrangedSubview:arrangedView];
      [arrangedView removeFromSuperview];
    }
  }
  
  // Helper for adding labels. We use separate labels for each paragraph
  // so that VoiceOver can be controlled paragraph-by-paragraph.
  void (^addLabelWithText)(NSString *) = ^(NSString *text) {
    PTSDynamicTypeLabel *label = [[PTSDynamicTypeLabel alloc] initWithFrame:CGRectZero];
    label.fontTextStyle = UIFontTextStyleBody;
    label.numberOfLines = 0;
    label.text = text;

    // Always insert above the buttons.
    NSInteger insertionIndex = MAX(self.stackView.arrangedSubviews.count - 1, 0);
    [self.stackView insertArrangedSubview:label atIndex:insertionIndex];
  };
  
  switch (self.therapySession.distressOutcome) {
    case PTSTherapySessionDistressOutcomeDecreased: {
      self.navigationItem.title = NSLocalizedString(@"Distress Decreased", nil);
      
      addLabelWithText([NSString stringWithFormat:
                        NSLocalizedString(@"Great! It looks like %@ may have brought down your distress "
                                          "level. Try to remember this tool. Anything that works for you "
                                          "once can work for you again!", nil),
                        self.therapySession.currentTool.title]);
      
      addLabelWithText(NSLocalizedString(@"If a tool continues to work for you, you may want to give "
                                         "it a \"thumbs up\" by tapping the thumbs up button the next "
                                         "time you're given this tool. That way, it will be more likely "
                                         "to come up again. The tool will also be saved in \"Favorites.\"", nil));
      break;
    }
      
    case PTSTherapySessionDistressOutcomeIncreased: {
      self.navigationItem.title = NSLocalizedString(@"Distress Increased", nil);

      addLabelWithText([NSString stringWithFormat:
                        NSLocalizedString(@"Okay, it looks like after %@ you are actually more distressed. "
                                          "This might be good to remember for the future, since you shouldn’t "
                                          "do things that don’t work for you. But remember, some of these "
                                          "tools take time or practice to really work, or may only relieve "
                                          "certain types of problems, so don’t write this one off just yet.", nil),
                        self.therapySession.currentTool.title]);
      
      
      addLabelWithText(NSLocalizedString(@"If a tool continues to not work for you, you may want to \"give "
                                         "it a thumbs down\" by tapping the thumbs down button the next time "
                                         "you're given this tool. That way, it will be less likely to come up again.", nil));
      
      addLabelWithText(NSLocalizedString(@"Since you are still stressed, maybe you should try another tool.", nil));
      
      break;
    }
      
    case PTSTherapySessionDistressOutcomeUnchanged: {
      self.navigationItem.title = NSLocalizedString(@"Distress Unchanged", nil);
      
      addLabelWithText([NSString stringWithFormat:
                        NSLocalizedString(@"Okay, it looks like after %@ you have the same amount of distress. "
                                          "It’s possible that this is good enough for you – after all, nothing "
                                          "got worse! – or maybe you were hoping for a bigger improvement. But "
                                          "remember, some of these tools take time or practice to really work, "
                                          "or may only relieve certain types of problems, so don’t write this "
                                          "one off just yet.", nil),
                        self.therapySession.currentTool.title]);
      
      addLabelWithText(NSLocalizedString(@"If you feel like it, you could certainly try another tool now.", nil));
      
      break;
    }
      
    case PTSTherapySessionDistressOutcomeIncomplete: {
      NSAssert(FALSE, @"Distress outcome view controller should not be shown when outcome is incomplete.");
      break;
    }
  }
  
  switch (self.therapySession.context) {
    case PTSTherapySessionContextSymptom: {
      self.continueSessionWithSameToolButton.hidden = YES;
      self.continueSessionWithNewToolButton.hidden = NO;
      
      break;
    }
      
    case PTSTherapySessionContextTool: {
      self.continueSessionWithSameToolButton.hidden = NO;
      self.continueSessionWithNewToolButton.hidden = YES;

      break;
    }
  }
}

@end
