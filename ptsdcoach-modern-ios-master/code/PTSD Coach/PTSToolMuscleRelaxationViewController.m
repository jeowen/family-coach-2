//
//  PTSToolMuscleRelaxationViewController.m
//  PTSD Coach
//

@import AVFoundation;

#import "PTSToolMuscleRelaxationViewController.h"
#import "PTSAudioControlsView.h"
#import "PTSMediaCoordinator.h"
#import "PTSMediaMoment.h"
#import "PTSTool.h"
#import "PTSTimer.h"

#pragma mark - Private Interface

@interface PTSToolMuscleRelaxationViewController()

@property(nonatomic, weak) IBOutlet UILabel *captionsLabel;
@property(nonatomic, weak) IBOutlet UIView *imageViewsContainerView;
@property(nonatomic, weak) IBOutlet PTSAudioControlsView *audioControlsView;

@property(nonatomic, strong) UIImageView *bodyImageView;
@property(nonatomic, strong) UIImageView *bodyOverlayImageView;
@property(nonatomic, strong) UIImageView *armsOverlayImageView;
@property(nonatomic, strong) UIImageView *buttOverlayImageView;
@property(nonatomic, strong) UIImageView *feetOverlayImageView;
@property(nonatomic, strong) UIImageView *headOverlayImageView;
@property(nonatomic, strong) UIImageView *shouldersOverlayImageView;
@property(nonatomic, strong) UIImageView *stomachOverlayImageView;

@property(nonatomic, strong) PTSMediaCoordinator *captionsCoordinator;
@property(nonatomic, strong) NSLayoutConstraint *captionLabelHeightConstraint;

@end

#pragma mark - Implementation

@implementation PTSToolMuscleRelaxationViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  [self prepareImageViews];
  [self prepareAudioPlayback];
  [self prepareAnimationsForOverlayViews];

  [PTSTimer performBlockAfterDelay:1.0 block:^{
    [self.audioControlsView startPlayback];
  }];
}

/**
 *  viewDidLayoutSubviews
 */
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGFloat maximumHeight = 0.0;
  CGSize constraintSize = CGSizeMake(CGRectGetWidth(self.captionsLabel.frame), CGFLOAT_MAX);
  NSDictionary *attributes = @{ NSFontAttributeName : self.captionsLabel.font };
  
  for (PTSMediaMoment *moment in self.captionsCoordinator.mediaMoments) {
    NSString *caption = (NSString *)moment.userInfo;
    
    CGSize calculatedSize = [caption boundingRectWithSize:constraintSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil].size;

    maximumHeight = MAX(calculatedSize.height, maximumHeight);
  }
  
  if (!self.captionLabelHeightConstraint) {
    self.captionLabelHeightConstraint = [self.captionsLabel.heightAnchor constraintEqualToConstant:maximumHeight];
    self.captionLabelHeightConstraint.active = YES;
  } else {
    self.captionLabelHeightConstraint.constant = maximumHeight;
  }
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
  
  self.bodyImageView = makeImageView(@"Tool - Muscle Relaxation Body");
  self.bodyOverlayImageView = makeImageView(@"Tool - Muscle Relaxation Body Highlighted");
  self.armsOverlayImageView = makeImageView(@"Tool - Muscle Relaxation Arms");
  self.buttOverlayImageView = makeImageView(@"Tool - Muscle Relaxation Butt");
  self.feetOverlayImageView = makeImageView(@"Tool - Muscle Relaxation Feet");
  self.headOverlayImageView = makeImageView(@"Tool - Muscle Relaxation Head");
  self.shouldersOverlayImageView = makeImageView(@"Tool - Muscle Relaxation Shoulders");
  self.stomachOverlayImageView = makeImageView(@"Tool - Muscle Relaxation Stomach");
  
  // The main body image view is always visibile;
  self.bodyImageView.layer.opacity = 1.0;
}

/**
 *  prepareAnimationsForOverlayViews
 */
- (void)prepareAnimationsForOverlayViews {
  
  void (^applyFadeInFadeOutAnimation)(UIView *, NSTimeInterval, NSTimeInterval) = ^(UIView *view, NSTimeInterval start, NSTimeInterval duration) {
    NSArray *keyTimes = @[@(0.0), @(0.05), @(0.95), @(1.0)];
    NSArray *values = @[@(0.0), @(1.0), @(1.0), @(0.0)];
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.beginTime = start;
    opacityAnimation.duration = duration;
    
    opacityAnimation.values = values;
    opacityAnimation.keyTimes = keyTimes;

    [view.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
  };
  
  // Animations for showing the highlighted overlays. First number is the start time, in seconds
  // while the second number is the duration, offset from the start time. All times should be
  // relative to the start time (zero) of the audio track.
  // E.x.: A pairing of (30, 10) would mean that the animation starts 30 seconds after the audio
  // has started and lasts for 10 seconds.
  applyFadeInFadeOutAnimation(self.armsOverlayImageView, 62, 40);
  applyFadeInFadeOutAnimation(self.headOverlayImageView, 115, 60);
  applyFadeInFadeOutAnimation(self.shouldersOverlayImageView, 184, 52);
  applyFadeInFadeOutAnimation(self.stomachOverlayImageView, 245, 37);
  applyFadeInFadeOutAnimation(self.buttOverlayImageView, 297, 40);
  applyFadeInFadeOutAnimation(self.feetOverlayImageView, 357, 54);
  applyFadeInFadeOutAnimation(self.bodyOverlayImageView, 458, 20);
}

/**
 *  prepareAudioPlayback
 */
- (void)prepareAudioPlayback {
  NSAssert(self.tool.audioURL, @"Missing audio URL (or tool) for muscle relaxation exercise.");
  NSAssert(self.tool.captionsURL, @"Missing captions URL (or tool) for muscle relaxation exercise.");
  NSAssert(self.audioControlsView, @"AudioControlsView must be connected from Interface Builder");
  
  // Configure Audio Controls View
  PTSToolMuscleRelaxationViewController *__weak weakSelf = self;

  self.audioControlsView.layoutMargins = UIEdgeInsetsZero;
  self.audioControlsView.timerSyncCallbackBlock = ^(AVAudioPlayer *audioPlayer) {
    PTSToolMuscleRelaxationViewController *strongSelf = weakSelf;
    
    if (strongSelf) {
      CFTimeInterval offest = audioPlayer.currentTime;
      
      strongSelf.bodyImageView.layer.timeOffset = offest;
      strongSelf.bodyOverlayImageView.layer.timeOffset = offest;
      strongSelf.armsOverlayImageView.layer.timeOffset = offest;
      strongSelf.buttOverlayImageView.layer.timeOffset = offest;
      strongSelf.feetOverlayImageView.layer.timeOffset = offest;
      strongSelf.headOverlayImageView.layer.timeOffset = offest;
      strongSelf.shouldersOverlayImageView.layer.timeOffset = offest;
      strongSelf.stomachOverlayImageView.layer.timeOffset = offest;
      
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
