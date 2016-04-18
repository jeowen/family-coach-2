//
//  PTSToolDeepBreathingViewController.m
//  PTSD Coach
//

@import AVFoundation;

#import "PTSToolDeepBreathingViewController.h"
#import "PTSAudioControlsView.h"
#import "PTSDynamicTypeLabel.h"
#import "PTSMediaCoordinator.h"
#import "PTSMediaMoment.h"
#import "PTSTool.h"
#import "PTSTimer.h"

#define SCENE_TRANSITION_DURATION 2.5
#define SHADOW_VIEW_ALPHA 0.25
#define GREEN_BALL_VIEW_ALPHA 0.5
#define BALL_TRANSFORM_SCALE 0.25
#define LABEL_TRANSFORM_SCALE 0.25

#pragma mark - Private Interface

@interface PTSToolDeepBreathingViewController()

@property(nonatomic, weak) IBOutlet UILabel *captionsLabel;
@property(nonatomic, weak) IBOutlet UIView *imageViewsContainerView;
@property(nonatomic, weak) IBOutlet PTSAudioControlsView *audioControlsView;

@property(nonatomic, strong) UIImageView *redBallImageView;
@property(nonatomic, strong) UIImageView *greenBallImageView;
@property(nonatomic, strong) UIImageView *yellowBallImageView;

@property(nonatomic, strong) PTSDynamicTypeLabel *relaxLabel;
@property(nonatomic, strong) PTSDynamicTypeLabel *countingLabel;

@property(nonatomic, strong) NSMutableArray *greenBallAnimations;
@property(nonatomic, strong) NSMutableArray *yellowBallAnimations;
@property(nonatomic, strong) NSMutableArray *redBallAnimations;
@property(nonatomic, strong) NSMutableArray *relaxAnimations;
@property(nonatomic, strong) NSMutableArray *countingAnimations;

@property(nonatomic, assign) NSTimeInterval animationDuration;
@property(nonatomic, strong) PTSMediaCoordinator *mediaCoordinator;
@property(nonatomic, strong) PTSMediaCoordinator *captionsCoordinator;

@end

#pragma mark - Implementation

@implementation PTSToolDeepBreathingViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.animationDuration = 14.0;

  [self prepareImageViews];
  [self prepareOverlayLabels];
  [self prepareAudioPlayback];
  [self prepareAnimations];

  [PTSTimer performBlockAfterDelay:1.0 block:^{
    [self.audioControlsView startPlayback];
  }];
}

#pragma mark - PTSToolViewDelegate Methods

/**
 *  wantsFadeTransition
 */
- (BOOL)wantsFadeTransition {
  return YES;
}

#pragma mark - Private Methods

/**
 *  prepareImageViews
 */
- (void)prepareImageViews {
  NSAssert(self.imageViewsContainerView.subviews.count == 0, @"Should only call prepareImageViews once.");
  
  // Helper method so that all the image views are created the same way.
  UIImageView *(^makeImageView)(NSString *) = ^UIImageView *(NSString *imageName) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.opacity = 0.0;
    imageView.layer.speed = 0.0;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.imageViewsContainerView addSubview:imageView];
    
    [imageView.centerXAnchor constraintEqualToAnchor:self.imageViewsContainerView.centerXAnchor].active = YES;
    [imageView.centerYAnchor constraintEqualToAnchor:self.imageViewsContainerView.centerYAnchor].active = YES;
    
    [imageView.widthAnchor constraintLessThanOrEqualToAnchor:self.imageViewsContainerView.widthAnchor].active = YES;
    [imageView.heightAnchor constraintLessThanOrEqualToAnchor:self.imageViewsContainerView.heightAnchor].active = YES;
    
    return imageView;
  };
  
  self.greenBallImageView = makeImageView(@"Tool - Deep Breathing Ball Green");
  self.yellowBallImageView = makeImageView(@"Tool - Deep Breathing Ball Yellow");
  self.redBallImageView = makeImageView(@"Tool - Deep Breathing Ball Red");

  // Initial visibility and scale of green ball
  self.greenBallImageView.layer.opacity = 0.25;
  self.greenBallImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, BALL_TRANSFORM_SCALE, BALL_TRANSFORM_SCALE);
}

/**
 *  prepareOverlayLabels
 */
- (void)prepareOverlayLabels {
  self.relaxLabel = [[PTSDynamicTypeLabel alloc] initWithFrame:CGRectZero];
  self.relaxLabel.font = [UIFont systemFontOfSize:96.0 weight:UIFontWeightSemibold];
  self.relaxLabel.text = NSLocalizedString(@"Relax", nil);
  self.relaxLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.imageViewsContainerView addSubview:self.relaxLabel];
  
  [self.relaxLabel.centerXAnchor constraintEqualToAnchor:self.imageViewsContainerView.centerXAnchor].active = YES;
  [self.relaxLabel.centerYAnchor constraintEqualToAnchor:self.imageViewsContainerView.centerYAnchor].active = YES;
  
  self.countingLabel = [[PTSDynamicTypeLabel alloc] initWithFrame:CGRectZero];
  self.countingLabel.font = self.relaxLabel.font;
  self.countingLabel.text = NSLocalizedString(@"1", nil);
  self.countingLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.imageViewsContainerView addSubview:self.countingLabel];
  
  [self.countingLabel.centerXAnchor constraintEqualToAnchor:self.imageViewsContainerView.centerXAnchor].active = YES;
  [self.countingLabel.centerYAnchor constraintEqualToAnchor:self.imageViewsContainerView.centerYAnchor].active = YES;
  
  self.relaxLabel.layer.opacity = 0.0;
  self.countingLabel.layer.opacity = 0.0;

  self.relaxLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, LABEL_TRANSFORM_SCALE, LABEL_TRANSFORM_SCALE);
  self.countingLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, LABEL_TRANSFORM_SCALE, LABEL_TRANSFORM_SCALE);
}

/**
 *  prepareAudioPlayback
 */
- (void)prepareAudioPlayback {
  NSAssert(self.audioControlsView != nil, @"AudioControlsView should be set from Interface Builder");
  
  // Configure Audio Controls View
  PTSToolDeepBreathingViewController *__weak weakSelf = self;
  
  self.audioControlsView.layoutMargins = UIEdgeInsetsZero;
  self.audioControlsView.timerSyncCallbackBlock = ^(AVAudioPlayer *audioPlayer) {
    PTSToolDeepBreathingViewController *strongSelf = weakSelf;
    
    if (strongSelf) {
      CFTimeInterval offset = audioPlayer.currentTime;
      
      strongSelf.greenBallImageView.layer.timeOffset = offset;
      strongSelf.yellowBallImageView.layer.timeOffset = offset;
      strongSelf.redBallImageView.layer.timeOffset = offset;
      strongSelf.relaxLabel.layer.timeOffset = offset;
      strongSelf.countingLabel.layer.timeOffset = offset;
      
      [strongSelf.mediaCoordinator performMediaMomentForTime:offset performanceBlock:^(PTSMediaMoment *mediaMoment) {
        strongSelf.countingLabel.text = mediaMoment.userInfo;
      }];
      
      [strongSelf.captionsCoordinator performMediaMomentForTime:offset performanceBlock:^(PTSMediaMoment *mediaMoment) {
        [UIView transitionWithView:strongSelf.captionsLabel
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                          strongSelf.captionsLabel.text = mediaMoment.userInfo;
                        } completion:nil];
      }];
    }
  };
  
  [self.audioControlsView loadAudioFileWithURL:self.tool.audioURL autoplay:NO];
  self.captionsCoordinator = [PTSMediaCoordinator mediaCoordinatorWithCaptionsFile:self.tool.captionsURL];
}

/**
 *  prepareAnimations
 */
- (void)prepareAnimations {
  NSTimeInterval kStartOfCountingCycles = 72;
  NSTimeInterval kAnimationGroupDuration = self.audioControlsView.audioDuration;

  self.greenBallAnimations = [[NSMutableArray alloc] init];
  self.yellowBallAnimations = [[NSMutableArray alloc] init];
  self.redBallAnimations = [[NSMutableArray alloc] init];
  self.relaxAnimations = [[NSMutableArray alloc] init];
  self.countingAnimations = [[NSMutableArray alloc] init];
  self.mediaCoordinator = [[PTSMediaCoordinator alloc] init];
  
  // Start with two breathing cycles that don't show any text over top.
  [self makeAnimationsForBreatheCycleAtTimeOffset:44 countdownText:nil showRelaxLabel:NO];
  [self makeAnimationsForBreatheCycleAtTimeOffset:58 countdownText:nil showRelaxLabel:NO];
  
  // Now show 8 breathing cycles counting up from 1-8 and 8 more counting down from 8-1
  for (NSInteger i = 0; i < 8; i++) {
    NSTimeInterval sceneTimeOffset = kStartOfCountingCycles + (self.animationDuration * i);
    NSString *countdownText = [NSString stringWithFormat:@"%ld", i + 1];
    [self makeAnimationsForBreatheCycleAtTimeOffset:sceneTimeOffset
                                      countdownText:countdownText
                                     showRelaxLabel:YES];
    
    sceneTimeOffset = kStartOfCountingCycles + (self.animationDuration * 8) + (self.animationDuration * i);
    countdownText = [NSString stringWithFormat:@"%ld", 8 - i];
    [self makeAnimationsForBreatheCycleAtTimeOffset:sceneTimeOffset
                                      countdownText:countdownText
                                     showRelaxLabel:YES];
  }
  
  // Helper method for adding animations to appropriate target layer.
  void (^addAnimations)(NSArray *, UIView *) = ^(NSArray *animations, UIView *view) {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animations;
    animationGroup.duration = kAnimationGroupDuration;
    
    [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
  };
  
  addAnimations(self.greenBallAnimations, self.greenBallImageView);
  addAnimations(self.yellowBallAnimations, self.yellowBallImageView);
  addAnimations(self.redBallAnimations, self.redBallImageView);
  addAnimations(self.relaxAnimations, self.relaxLabel);
  addAnimations(self.countingAnimations, self.countingLabel);
}

/**
 *  makeAnimationsForBreatheCycleAtTimeOffset
 */
- (void)makeAnimationsForBreatheCycleAtTimeOffset:(NSTimeInterval)timeOffset
                                    countdownText:(NSString *)countdownText
                                   showRelaxLabel:(BOOL)showRelaxLabel {
  
  //  **************************************************************
  //  The breathing animation cycle goes like this:
  //  1. Expand green ball (shrink back down behind-the-scenes)
  //  2. Crossfade from green ball to yellow ball
  //  3. Hold on yellow ball
  //  4. Crossfade from yellow ball to red ball
  //  5. Shrink red ball
  //  6. Crossfade back to shrunken greenball.
  //  **************************************************************
  
  // In and out markers for each ball. Note that these are relative to the duration
  // of the animation. (i.e.: 0.25 is 1/4th of the way through the animation)
  CGFloat kMarkStart = 0.0;
  CGFloat kMarkEnd = 1.0;
  
  CGFloat kGreenBallMarkIn = 0.0;
  CGFloat kGreenBallMarkOut = 0.4;
  CGFloat kYellowBallMarkIn = 0.4;
  CGFloat kYellowBallMarkOut = 0.6;
  CGFloat kRedBallMarkIn = 0.6;
  CGFloat kRedBallMarkOut = 0.9;
  CGFloat kRelaxLabelMarkIn = kRedBallMarkIn + 0.1;
  CGFloat kRelaxLabelMarkOut = kMarkEnd;
  CGFloat kCountdownLabelMarkIn = kYellowBallMarkIn - 0.05;
  CGFloat kCountdownLabelMarkOut = kYellowBallMarkOut;
  
  // Relative amount to overlap the crossfades.
  CGFloat kCrossfadeOverlap = 0.05;
  
  // Scale amount for the green and red balls
  CGFloat kScaleAmount = BALL_TRANSFORM_SCALE;
  
  //
  // Shared scaling animations
  //
  NSArray *sharedScaleValues = @[
                                @(kScaleAmount),
                                @(1.0),
                                @(1.0),
                                @(kScaleAmount)];
  
  NSArray *sharedScaleKeyTimes = @[
                                  @(kMarkStart),
                                  @(kYellowBallMarkIn),
                                  @(kRedBallMarkIn),
                                  @(kMarkEnd)];
  
  CAKeyframeAnimation *sharedScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  sharedScaleAnimation.beginTime = timeOffset;
  sharedScaleAnimation.duration = self.animationDuration;
  sharedScaleAnimation.values = sharedScaleValues;
  sharedScaleAnimation.keyTimes = sharedScaleKeyTimes;

  [self.greenBallAnimations addObject:sharedScaleAnimation];
  [self.yellowBallAnimations addObject:sharedScaleAnimation];
  [self.redBallAnimations addObject:sharedScaleAnimation];
  
  //
  // Shadow opacity animation
  //
  NSArray *shadowBallOpacityValues = @[
                                      @(SHADOW_VIEW_ALPHA),
                                      @(1.0),
                                      @(1.0),
                                      @(SHADOW_VIEW_ALPHA)];
  
  NSArray *shadowBallOpacityKeyTimes = @[
                                        @(kMarkStart),
                                        @(kGreenBallMarkOut),
                                        @(kRedBallMarkIn),
                                        @(kMarkEnd)];
  
  CAKeyframeAnimation *shadowBallOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
  shadowBallOpacityAnimation.duration = self.animationDuration;
  shadowBallOpacityAnimation.values = shadowBallOpacityValues;
  shadowBallOpacityAnimation.keyTimes = shadowBallOpacityKeyTimes;
  
  //
  // Green Ball opacity animation
  //

  NSArray *greenBallOpacityValues = @[
                                     @(GREEN_BALL_VIEW_ALPHA),
                                     @(1.0),
                                     @(1.0),
                                     @(GREEN_BALL_VIEW_ALPHA)];
  
  NSArray *greenBallOpacityKeyTimes = @[
                                       @(kGreenBallMarkIn),
                                       @(kGreenBallMarkOut),
                                       @(kRedBallMarkOut),
                                       @(kRedBallMarkOut + kCrossfadeOverlap)];
  
  CAKeyframeAnimation *greenBallOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
  greenBallOpacityAnimation.beginTime = timeOffset;
  greenBallOpacityAnimation.duration = self.animationDuration;
  greenBallOpacityAnimation.values = greenBallOpacityValues;
  greenBallOpacityAnimation.keyTimes = greenBallOpacityKeyTimes;
  
  [self.greenBallAnimations addObject:greenBallOpacityAnimation];
  
  //
  // Yellow Ball opacity animation
  //
  NSArray *yellowBallOpacityValues = @[
                                      @(0.0),
                                      @(1.0),
                                      @(1.0),
                                      @(0.0)];
  
  NSArray *yellowBallOpacityKeyTimes = @[
                                        @(kYellowBallMarkIn),
                                        @(kYellowBallMarkIn + kCrossfadeOverlap),
                                        @(kYellowBallMarkOut),
                                        @(kYellowBallMarkOut + kCrossfadeOverlap)];
  
  CAKeyframeAnimation *yellowBallOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
  yellowBallOpacityAnimation.beginTime = timeOffset;
  yellowBallOpacityAnimation.duration = self.animationDuration;
  yellowBallOpacityAnimation.values = yellowBallOpacityValues;
  yellowBallOpacityAnimation.keyTimes = yellowBallOpacityKeyTimes;
  
  [self.yellowBallAnimations addObject:yellowBallOpacityAnimation];
  
  //
  // Red Ball opacity animation
  //
  NSArray *redBallOpacityValues = @[
                                   @(0.0),
                                   @(1.0),
                                   @(1.0),
                                   @(0.0)];
  
  NSArray *redBallOpacityKeyTimes = @[
                                     @(kRedBallMarkIn),
                                     @(kRedBallMarkIn + kCrossfadeOverlap),
                                     @(kRedBallMarkOut),
                                     @(kRedBallMarkOut + kCrossfadeOverlap)];
  
  CAKeyframeAnimation *redBallOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
  redBallOpacityAnimation.beginTime = timeOffset;
  redBallOpacityAnimation.duration = self.animationDuration;
  redBallOpacityAnimation.values = redBallOpacityValues;
  redBallOpacityAnimation.keyTimes = redBallOpacityKeyTimes;
  
  [self.redBallAnimations addObject:redBallOpacityAnimation];
  
  if (countdownText) {
    //
    // Counting label opacity animation
    //
    NSArray *countdownLabelOpacityValues = @[
                                            @(0.0),
                                            @(1.0),
                                            @(0.0)];
    NSArray *countdownLabelOpacityKeyTimes = @[
                                              @(kCountdownLabelMarkIn),
                                              @(kCountdownLabelMarkIn + kCrossfadeOverlap),
                                              @(kCountdownLabelMarkOut)];
    
    CAKeyframeAnimation *countdownLabelOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    countdownLabelOpacityAnimation.beginTime = timeOffset;
    countdownLabelOpacityAnimation.duration = self.animationDuration;
    countdownLabelOpacityAnimation.values = countdownLabelOpacityValues;
    countdownLabelOpacityAnimation.keyTimes = countdownLabelOpacityKeyTimes;
    
    [self.countingAnimations addObject:countdownLabelOpacityAnimation];
    
    //
    // Counting label scaling animation
    //
    NSArray *countdownLabelScaleValues = @[
                                          @(LABEL_TRANSFORM_SCALE),
                                          @(1.0)];
    NSArray *countdownLabelScaleKeyTimes = @[
                                            @(kCountdownLabelMarkIn),
                                            @(kCountdownLabelMarkOut)];
    
    CAKeyframeAnimation *countdownLabelScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    countdownLabelScaleAnimation.beginTime = timeOffset;
    countdownLabelScaleAnimation.duration = self.animationDuration;
    countdownLabelScaleAnimation.values = countdownLabelScaleValues;
    countdownLabelScaleAnimation.keyTimes = countdownLabelScaleKeyTimes;
    
    [self.countingAnimations addObject:countdownLabelScaleAnimation];

    PTSMediaMoment *mediaMoment = [[PTSMediaMoment alloc] initWithTime:timeOffset userInfo:countdownText];
    [self.mediaCoordinator addMediaMoment:mediaMoment];
  }
  
  if (showRelaxLabel) {
    //
    // Relax label opacity animation
    //
    NSArray *relaxLabelOpacityValues = @[
                                        @(0.0),
                                        @(1.0),
                                        @(0.0)];
    NSArray *relaxLabelOpacityKeyTimes = @[
                                          @(kRelaxLabelMarkIn),
                                          @(kRelaxLabelMarkIn + kCrossfadeOverlap),
                                          @(kRelaxLabelMarkOut)];
    
    CAKeyframeAnimation *relaxLabelOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    relaxLabelOpacityAnimation.beginTime = timeOffset;
    relaxLabelOpacityAnimation.duration = self.animationDuration;
    relaxLabelOpacityAnimation.values = relaxLabelOpacityValues;
    relaxLabelOpacityAnimation.keyTimes = relaxLabelOpacityKeyTimes;
    
    [self.relaxAnimations addObject:relaxLabelOpacityAnimation];
    
    //
    // Relax label scale animation
    //
    NSArray *relaxLabelScaleValues = @[
                                      @(LABEL_TRANSFORM_SCALE),
                                      @(1.0)];
    NSArray *relaxLabelScaleKeyTimes = @[
                                        @(kRelaxLabelMarkIn),
                                        @(kRelaxLabelMarkOut)];
    
    CAKeyframeAnimation *relaxLabelScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    relaxLabelScaleAnimation.beginTime = timeOffset;
    relaxLabelScaleAnimation.duration = self.animationDuration;
    relaxLabelScaleAnimation.values = relaxLabelScaleValues;
    relaxLabelScaleAnimation.keyTimes = relaxLabelScaleKeyTimes;
    
    [self.relaxAnimations addObject:relaxLabelScaleAnimation];
  }
}

@end
