//
//  PTSToolMindfulLookingViewController.m
//  PTSD Coach
//

#import "PTSToolMindfulLookingViewController.h"
#import "PTSRandomContentProvider.h"
#import "PTSDatastore.h"
#import "PTSDurationPickerViewController.h"
#import "PTSTimer.h"
#import "PTSTimerLabel.h"
#import "PTSTool.h"

#pragma mark - Private Interface

@interface PTSToolMindfulLookingViewController()<UIPopoverPresentationControllerDelegate>

@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, weak) IBOutlet PTSTimerLabel *timerLabel;

@property(nonatomic, strong) PTSTimer *countdownTimer;
@property(nonatomic, assign) NSTimeInterval timerDuration;
@property(nonatomic, strong) PTSRandomContentProvider *randomContentProvider;
@property(nonatomic, strong) PTSDurationPickerViewController *durationPickerViewController;

@end

#pragma mark - Implementation

@implementation PTSToolMindfulLookingViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  PTSToolMindfulLookingViewController *__weak weakSelf = self;
  
  // Load photos from data store
  NSArray *photos = [PTSDatastore sharedDatastore].mindfulPhotos;
  self.randomContentProvider = [[PTSRandomContentProvider alloc] initWithContentItems:photos];

  // Default duration is 5 minutes
  self.timerDuration = 5 * 60;
  
  self.countdownTimer = [[PTSTimer alloc] initWithDuration:self.timerDuration];
  self.countdownTimer.callbackBlock = ^(PTSTimer *timer) {
    [weakSelf updateElementsFromCurrentTimerState];
  };
  
  // Add gesture recognizer to image view so that users can tap on the image to cycle to the next one.
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTappedGesture:)];
  tapGestureRecognizer.numberOfTapsRequired = 1;

  [self.imageView addGestureRecognizer:tapGestureRecognizer];
  self.imageView.image = [self.randomContentProvider nextContentItem];
  
  // Allow the user to tap on the timer label to change the timer duration
  self.timerLabel.text = self.countdownTimer.durationStringValue;
  self.timerLabel.tappedCallbackBlock = ^(PTSTimerLabel *label) {
    [weakSelf showDurationPickerViewWithSourceView:label];
  };
  
  // Auto start the timer after a brief delay so that it's not so sudden.
  [PTSTimer performBlockAfterDelay:1.0 block:^{
    [self handlePlayButtonPressed:nil];
  }];
}

#pragma mark - IBActions

/**
 *  handlePlayButtonPressed
 */
- (IBAction)handlePlayButtonPressed:(id)sender {
  if (self.countdownTimer.isRunning) {
    [self.countdownTimer stop];
  } else {
    [self.countdownTimer start];
  }

  [self updateElementsFromCurrentTimerState];
}

#pragma mark - UIAdaptivePresentationControllerDelegate Methods

/**
 *  adaptivePresentationStyleForPresentationController
 */

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
  return UIModalPresentationNone;
}

#pragma mark - ActionHandlers

/**
 *  handleImageViewTappedGesture
 */
- (void)handleImageViewTappedGesture:(id)sender {
  self.imageView.image = [self.randomContentProvider nextContentItem];
}

#pragma mark - Private Methods

/**
 *  updateElementsFromCurrentTimerState
 */
- (void)updateElementsFromCurrentTimerState {
  
  // Timer label shows the time remaining.
  self.timerLabel.text = self.countdownTimer.timeRemainingStringValue;

  [UIView performWithoutAnimation:^{
    if (self.countdownTimer.isRunning) {
      [self.playButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
    } else {
      [self.playButton setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
    }
    
    [self.playButton layoutIfNeeded];
  }];
}

/**
 *  showDurationPickerViewWithSourceView
 */
- (void)showDurationPickerViewWithSourceView:(UIView *)sourceView {
  if (!self.durationPickerViewController) {
    PTSToolMindfulLookingViewController *__weak weakSelf = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSDurationPickerStoryboard" bundle:nil];
    self.durationPickerViewController = [storyboard instantiateInitialViewController];
    self.durationPickerViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.durationPickerViewController.callbackBlock = ^(NSTimeInterval duration) {
      weakSelf.countdownTimer.duration = duration;
    };
  }
  
  UIPopoverPresentationController *presentationController = self.durationPickerViewController.popoverPresentationController;
  presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
  presentationController.sourceView = sourceView;
  presentationController.sourceRect = sourceView.bounds;
  presentationController.delegate = self;
  
  [self presentViewController:self.durationPickerViewController animated:YES completion:nil];
}

@end
