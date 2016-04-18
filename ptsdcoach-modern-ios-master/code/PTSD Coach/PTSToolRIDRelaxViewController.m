//
//  PTSToolRIDRelaxViewController.m
//  PTSD Coach
//

#import "PTSToolRIDRelaxViewController.h"
#import "PTSTimer.h"

static const NSTimeInterval PTSToolRIDRelaxTimerDuration = 30;

#pragma mark - Private Interface

@interface PTSToolRIDRelaxViewController()

@property(nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property(nonatomic, weak) IBOutlet UIButton *additionalTimeButton;

@property(nonatomic, strong) PTSTimer *timer;

@end

#pragma mark - Implementation

@implementation PTSToolRIDRelaxViewController

#pragma mark - UIViewController Methods

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.additionalTimeButton.enabled = NO;
  self.countdownLabel.text = [@(PTSToolRIDRelaxTimerDuration) stringValue];
  
  [PTSTimer performBlockAfterDelay:1.0 block:^{
    [self startTimer];
  }];
}

/**
 *  viewWillDisappear
 */
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.timer stop];
}

#pragma mark - IBActions

/**
 *  handleAdditionalTimeButtonPressed
 */
- (IBAction)handleAdditionalTimeButtonPressed:(id)sender {
  [self startTimer];
}

#pragma mark - Private Methods

/**
 *  startTimer
 */
- (void)startTimer {
  [self.timer stop];
  
  PTSToolRIDRelaxViewController *__weak weakSelf = self;
  
  self.additionalTimeButton.enabled = NO;
  
  self.timer = [[PTSTimer alloc] initWithDuration:PTSToolRIDRelaxTimerDuration];
  self.timer.callbackBlock = ^(PTSTimer *timer) {
    weakSelf.countdownLabel.text = timer.timeRemainingStringValue;
    weakSelf.additionalTimeButton.enabled = !(timer.timeRemaining > 0);
  };
  
  [self.timer start];
}

@end
