//
//  PTSToolAudioExerciseViewController.m
//  PTSD Coach
//

@import AVFoundation;

#import "PTSToolAudioExerciseViewController.h"
#import "PTSAudioControlsView.h"
#import "PTSContentLoader.h"
#import "PTSMediaCoordinator.h"
#import "PTSMediaMoment.h"
#import "PTSTimer.h"
#import "PTSTool.h"

#pragma mark - Private Interface

@interface PTSToolAudioExerciseViewController()

@property(nonatomic, weak) IBOutlet UILabel *captionsLabel;
@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, weak) IBOutlet PTSAudioControlsView *audioControlsView;

@property(nonatomic, strong) PTSMediaCoordinator *captionsCoordinator;

@end

#pragma mark - Implementation

@implementation PTSToolAudioExerciseViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Clear out the helper text that is only used in Interface Builder
  self.captionsLabel.text = nil;
  
  [self prepareImageView];
  [self prepareAudioPlayback];
  
  [PTSTimer performBlockAfterDelay:1.0 block:^{
    [self.audioControlsView startPlayback];
  }];
}

#pragma mark - PTSToolViewDelegate Methods

/**
 *  wantsFadeTransition
 */
- (BOOL)wantsFadeTransition {
  return  YES;
}

#pragma mark - Private Methods


/**
 *  prepareImageView
 */
- (void)prepareImageView {
  if (self.tool.audioExerciseImageName) {
    self.imageView.image = [UIImage imageNamed:self.tool.audioExerciseImageName];
  } else {
    self.imageView.hidden = YES;
  }
}

/**
 *  prepareAudioPlayback
 */
- (void)prepareAudioPlayback {
  NSAssert(self.audioControlsView != nil, @"AudioControlsView should be set from Interface Builder");
  
  // Configure Audio Controls View
  PTSToolAudioExerciseViewController *__weak weakSelf = self;
  
  self.audioControlsView.layoutMargins = UIEdgeInsetsZero;
  self.audioControlsView.timerSyncCallbackBlock = ^(AVAudioPlayer *audioPlayer) {
    PTSToolAudioExerciseViewController *strongSelf = weakSelf;
    
    if (strongSelf) {
      CFTimeInterval offest = audioPlayer.currentTime;
      
      [strongSelf.captionsCoordinator performMediaMomentForTime:offest performanceBlock:^(PTSMediaMoment *mediaMoment) {
        [UIView transitionWithView:strongSelf.captionsLabel
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                          strongSelf.captionsLabel.text = mediaMoment.userInfo;
                        }
                        completion:nil];
      }];
    }
  };

  [self.audioControlsView loadAudioFileWithURL:self.tool.audioURL autoplay:NO];
  self.captionsCoordinator = [PTSMediaCoordinator mediaCoordinatorWithCaptionsFile:self.tool.captionsURL];
}

@end
