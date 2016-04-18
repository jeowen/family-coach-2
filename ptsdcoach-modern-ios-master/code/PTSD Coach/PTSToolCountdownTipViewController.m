//
//  PTSToolCountdownTipViewController.m
//  PTSD Coach
//

#import "PTSToolCountdownTipViewController.h"
#import "PTSTool.h"
#import "PTSTimer.h"
#import "PTSRandomContentProvider.h"

#pragma mark - Private Interface

@interface PTSToolCountdownTipViewController()

@property(nonatomic, weak) IBOutlet UILabel *introductionLabel;
@property(nonatomic, weak) IBOutlet UIButton *startButton;
@property(nonatomic, weak) IBOutlet UILabel *tipLabel;
@property(nonatomic, weak) IBOutlet UILabel *countdownLabel;

@property(nonatomic, strong) PTSTimer *timer;
@property(nonatomic, assign) NSTimeInterval timerDuration;
@property(nonatomic, strong) PTSRandomContentProvider *randomContentProvider;

@end

#pragma mark - Implementation

@implementation PTSToolCountdownTipViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set a monospace font on the label.
  UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
  self.countdownLabel.font = [UIFont monospacedDigitSystemFontOfSize:fontDescriptor.pointSize
                                                              weight:UIFontWeightRegular];
  
  [self loadContent];
}

#pragma mark - IBActions

/**
 *  handleStartButtonPressed
 */
- (IBAction)handleStartButtonPressed:(id)sender {
  NSDictionary *item = [self.randomContentProvider nextContentItem];
  
  self.introductionLabel.hidden = YES;
  self.startButton.hidden = YES;
  self.tipLabel.hidden = NO;
  self.countdownLabel.hidden = NO;
  
  self.tipLabel.text = item[@"tip"];
  self.countdownLabel.text = @"";
  
  PTSToolCountdownTipViewController *__weak weakSelf = self;
  [self.timer stop];
  
  self.timer = [[PTSTimer alloc] initWithDuration:self.timerDuration];
  self.timer.callbackBlock = ^(PTSTimer *timer) {
    weakSelf.countdownLabel.text = timer.timeRemainingStringValue;
    weakSelf.countdownLabel.hidden = !(timer.timeRemaining > 0);
  };
  
  self.countdownLabel.text = self.timer.timeRemainingStringValue;
  self.countdownLabel.hidden = NO;
  
  [PTSTimer performBlockAfterDelay:1.0 block:^{
    [self.timer start];
  }];
}

#pragma mark - Private Methods

/**
 *  loadContent
 */
- (void)loadContent {
  NSAssert(self.tool != nil, @"Countdown tip view must have an assigned tool.");
  
  // Default timer duration is 5 minutes
  self.timerDuration = 5 * 60;
  
  self.introductionLabel.hidden = NO;
  self.startButton.hidden = NO;
  self.tipLabel.hidden = YES;
  self.countdownLabel.hidden = YES;
  
  switch (self.tool.identifier) {
    case PTSToolIdentifierThoughtStopping: {
      NSArray *contentItems = [NSArray arrayWithContentsOfURL:self.tool.contentURL];
      self.randomContentProvider = [[PTSRandomContentProvider alloc] initWithContentItems:contentItems];
      
      [self.startButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
      self.introductionLabel.text = NSLocalizedString(@"You can learn to interrupt the unhelpful thoughts that "
                                                      "make you angry before you do or say something you’ll regret. "
                                                      "The key is to interrupt your thinking and say a phrase to "
                                                      "yourself to counteract those angry thoughts before you get into trouble.", nil);
      break;
    }
      
    case PTSToolIdentifierTimeOut: {
      NSArray *contentItems = [NSArray arrayWithContentsOfURL:self.tool.contentURL];
      self.randomContentProvider = [[PTSRandomContentProvider alloc] initWithContentItems:contentItems];

      [self.startButton setTitle:NSLocalizedString(@"Take a Time Out", nil) forState:UIControlStateNormal];
      self.introductionLabel.text = NSLocalizedString(@"Sometimes the most effective thing to do is take a time out. "
                                                      "This is especially helpful if your anger is escalating and you "
                                                      "might do something hurtful or with consequences that you’d later "
                                                      "regret. The goal is to avoid making a hard situation worse.", nil);
      break;
    }
      
    default: {
      NSAssert(FALSE, @"Invalid tool for countdown timer view.");
      break;
    }
  }
}

@end
