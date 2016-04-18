//
//  PTSAudioControlsView.m
//  PTSD Coach
//

@import AVFoundation;

#import "PTSAudioControlsView.h"
#import "PTSTimer.h"
#import "PTSStyleKit.h"

#pragma mark - Private Interface

@interface PTSAudioControlsView()<AVAudioPlayerDelegate>

@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UILabel *currentTimeLabel;
@property(nonatomic, strong) UILabel *timeRemainingLabel;
@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) UIView *topSeparatorView;

@property(nonatomic, strong) PTSTimer *timer;
@property(nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic, assign, getter = shouldResumePlaybackAfterTouchControlEvent) BOOL resumePlaybackAfterTouchControlEvent;
@property(nonatomic, assign, getter = isEnabled) BOOL enabled;

@end

#pragma mark - Implementation

@implementation PTSAudioControlsView

#pragma mark - Lifecycle

/**
 *  initWithFrame
 */
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  
  return self;
}

/**
 *  awakeFromNib
 */
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self commonInit];
}

/**
 *  dealloc
 */
- (void)dealloc {
  self.audioPlayer = nil;
}

#pragma mark - UIView Methods

/**
 *  intrinsincContentSize
 */
- (CGSize)intrinsicContentSize {
  return CGSizeMake(UIViewNoIntrinsicMetric , 44.0);
}

#pragma mark - Public Properties

/**
 *  setAudioPlayer
 */
- (void)setAudioPlayer:(AVAudioPlayer *)audioPlayer {
  if (_audioPlayer) {
    [_audioPlayer stop];
    
    _audioPlayer = nil;
  }
  
  _audioPlayer = audioPlayer;
}

#pragma mark - Public Properties

/**
 *  audioDuration
 */
- (NSTimeInterval)audioDuration {
  return self.audioPlayer.duration;
}

/**
 *  setTimerSyncCallbackBlock
 */

- (void)setTimerSyncCallbackBlock:(PTSAudioControlsTimerSyncCallbackBlock)timerSyncCallbackBlock {
  _timerSyncCallbackBlock = timerSyncCallbackBlock;
  
  if (_timerSyncCallbackBlock) {
    self.timer.firingInterval = 1.0 / 30.0;
  } else {
    self.timer.firingInterval = 1.0 / 10.0;
  }
}

/**
 *  setWantsSeparator
 */
- (void)setWantsSeparator:(BOOL)wantsSeparator {
  _wantsSeparator = wantsSeparator;
  self.topSeparatorView.hidden = !wantsSeparator;
}

/**
 *  separatorColor
 */
- (void)setSeparatorColor:(UIColor *)separatorColor {
  _separatorColor = separatorColor;
  self.topSeparatorView.backgroundColor = separatorColor;
}

#pragma mark - Public Methods

/**
 *  loadAudioFileWithURL
 */
- (void)loadAudioFileWithURL:(NSURL *)URL autoplay:(BOOL)autoplay {
  [self stopPlayback];
  
  self.audioPlayer.delegate = nil;
  self.audioPlayer = nil;
  
  NSError *error;
  
  self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
  self.audioPlayer.delegate = self;
  [self.audioPlayer prepareToPlay];

  self.enabled = (self.audioPlayer && !error);
  
  [self updateLabels];
  [self updatePlayButton];
  [self updateSlider];
  
  if (autoplay) {
    [self startPlayback];
  }
}

#pragma mark - AVAudioPlayerDelegate Methods

/**
 *  audioPlayerDidFinishPlaying:successfully
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  // Here for completeness, but the PTSTimer callback should detect that isPlaying has changed.
}

#pragma mark - Action Handlers

/**
 *  handlePlayButtonPressed
 */
- (void)handlePlayButtonPressed:(id)sender {
  [self togglePlayback];
}

/**
 *  handleSliderTouchDownControlEvent
 */
- (void)handleSliderTouchDownControlEvent:(id)sender {
  self.resumePlaybackAfterTouchControlEvent = self.audioPlayer.isPlaying;

  [self stopPlayback];
}

/**
 *  handleSliderTouchUpControlEvent
 */
- (void)handleSliderTouchUpControlEvent:(id)sender {
  if (self.shouldResumePlaybackAfterTouchControlEvent) {
    [self startPlayback];
  }
}

/**
 *  handleSliderValueChanged
 */
- (void)handleSliderValueChanged:(id)sender {
  CGFloat offset = self.slider.value;
  self.audioPlayer.currentTime = (self.audioPlayer.duration * offset);
  
  [self updateLabels];

  if (self.timerSyncCallbackBlock) {
    self.timerSyncCallbackBlock(self.audioPlayer);
  }
}

/**
 *  handleTimerDidFire
 */
- (void)handleTimerDidFire:(PTSTimer *)timer {
  [self updateLabels];
  [self updateSlider];
  [self updatePlayButton];
  
  if (!self.audioPlayer.isPlaying) {
    [timer stop];
  }
  
  if (self.timerSyncCallbackBlock) {
    self.timerSyncCallbackBlock(self.audioPlayer);
  }
}

#pragma mark - Private Properties

/**
 *  setEnabled
 */
- (void)setEnabled:(BOOL)enabled {
  self.slider.enabled = enabled;
  self.currentTimeLabel.enabled = enabled;
  self.timeRemainingLabel.enabled = enabled;
  
  self.playButton.hidden = !enabled;
}

#pragma mark - Private Methods

/**
 *  commonInit
 */
- (void)commonInit {
  UIFont *labelFont = [UIFont monospacedDigitSystemFontOfSize:12.0 weight:UIFontWeightRegular];
  
  // Play/Pause button
  self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.playButton.translatesAutoresizingMaskIntoConstraints = NO;

  [self.playButton setImage:[PTSStyleKit imageOfAudioPlayButtonImage] forState:UIControlStateNormal];
  [self.playButton setImage:[PTSStyleKit imageOfAudioPlayButtonImage] forState:UIControlStateHighlighted];
  [self.playButton setImage:[PTSStyleKit imageOfAudioPauseButtonImage] forState:UIControlStateSelected];
  [self.playButton setImage:[PTSStyleKit imageOfAudioPauseButtonImage] forState:UIControlStateSelected | UIControlStateHighlighted];
  
  [self.playButton addTarget:self action:@selector(handlePlayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  // Current playback time label
  self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.currentTimeLabel.font = labelFont;
  self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
  self.currentTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Time remaining label
  self.timeRemainingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.timeRemainingLabel.font = self.currentTimeLabel.font;
  self.timeRemainingLabel.textAlignment = self.currentTimeLabel.textAlignment;
  self.timeRemainingLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Playback time slider scrubber.
  self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
  self.slider.minimumValue = 0.0;
  self.slider.maximumValue = 1.0;
  self.slider.translatesAutoresizingMaskIntoConstraints = NO;

  [self.slider addTarget:self action:@selector(handleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
  [self.slider addTarget:self action:@selector(handleSliderTouchDownControlEvent:) forControlEvents:UIControlEventTouchDown];
  [self.slider addTarget:self action:@selector(handleSliderTouchUpControlEvent:) forControlEvents:UIControlEventTouchUpInside];
  [self.slider addTarget:self action:@selector(handleSliderTouchUpControlEvent:) forControlEvents:UIControlEventTouchUpOutside];

  // Container stack view for hosting the playback controls
  UIStackView *controlsStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
  controlsStackView.axis = UILayoutConstraintAxisHorizontal;
  controlsStackView.spacing = 8.0;
  controlsStackView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [controlsStackView addArrangedSubview:self.playButton];
  [controlsStackView addArrangedSubview:self.currentTimeLabel];
  [controlsStackView addArrangedSubview:self.slider];
  [controlsStackView addArrangedSubview:self.timeRemainingLabel];
  
  // Top/Bottom padding views
  UIView *topPaddingView = [[UIView alloc] initWithFrame:CGRectZero];
  topPaddingView.translatesAutoresizingMaskIntoConstraints = NO;
  
  UIView *bottomPaddingView = [[UIView alloc] initWithFrame:CGRectZero];
  bottomPaddingView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [topPaddingView.heightAnchor constraintEqualToConstant:4].active = YES;
  [bottomPaddingView.heightAnchor constraintEqualToConstant:6].active = YES;
  
  // Main Host Stack View
  UIStackView *hostStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
  hostStackView.axis = UILayoutConstraintAxisVertical;
  hostStackView.alignment = UIStackViewAlignmentCenter;
  hostStackView.spacing = 2.0;
  hostStackView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [hostStackView addArrangedSubview:topPaddingView];
  [hostStackView addArrangedSubview:controlsStackView];
  [hostStackView addArrangedSubview:bottomPaddingView];
  
  [self addSubview:hostStackView];

  if (!self.separatorColor) {
    self.separatorColor = [UIColor colorWithWhite:0.75 alpha:1.0];
  }
  
  // Separator line across the top
  self.topSeparatorView = [[UIView alloc] initWithFrame:CGRectZero];
  self.topSeparatorView.backgroundColor = self.separatorColor;
  self.topSeparatorView.hidden = !self.wantsSeparator;
  self.topSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [hostStackView insertArrangedSubview:self.topSeparatorView atIndex:0];
  [self.topSeparatorView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
  
  // The height constraint needs to be allowed to be brokedn for the stack view to collapse.
  NSLayoutConstraint *heightConstraint = [self.topSeparatorView.heightAnchor constraintEqualToConstant:0.5];
  heightConstraint.priority = 999;
  heightConstraint.active = YES;

  [controlsStackView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-(self.layoutMargins.left + self.layoutMargins.right)].active = YES;
  
  // Pin main host stack view to our edges.
  [hostStackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
  [hostStackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
  [hostStackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;

  // Allow the bottom constraint to be broken because when the audio controls view is inside
  // a parent stack view, the parent stack view might attempt to set our height to zero before
  // attempting to hide us. The bottom constraint must be allowed to be broken for that to occur.
  NSLayoutConstraint *bottomConstraint = [hostStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
  bottomConstraint.active = YES;
  bottomConstraint.priority = 999;

  // We really don't want to be compressed vertically if we can avoid it...
  [self setContentCompressionResistancePriority:950 forAxis:UILayoutConstraintAxisVertical];
  
  // Determine a fixed width for the labels so that the layout doesn't get updated
  // as the text in each label is chagned.
  self.timeRemainingLabel.text = @"–00:00";
  [self.timeRemainingLabel sizeToFit];
  CGFloat labelWidth = CGRectGetWidth(self.timeRemainingLabel.frame);
  
  [self.currentTimeLabel.widthAnchor constraintEqualToConstant:labelWidth].active = YES;
  [self.timeRemainingLabel.widthAnchor constraintEqualToAnchor:self.currentTimeLabel.widthAnchor].active = YES;
  
  [self updateLabels];
  
  // AVAudioPlayer doesn't support KVO on the current time property. Using an AVPlayer object
  // is what we "should" be doing, but for now we'll just keep things simple and use our PTSTimer
  // object and poll for changes.
  PTSAudioControlsView *__weak weakSelf = self;
  
  self.timer = [PTSTimer infinityTimer];
  self.timer.callbackBlock = ^(PTSTimer *timer) {
    [weakSelf handleTimerDidFire:timer];
  };
  
  self.resumePlaybackAfterTouchControlEvent = NO;
  self.enabled = NO;
}

/**
 *  startPlayback
 */
- (void)startPlayback {
  [self.audioPlayer play];
  [self.timer start];
}

/**
 *  stopPlayback
 */
- (void)stopPlayback {
  [self.audioPlayer stop];
}

/**
 *  togglePlayback
 */
- (void)togglePlayback {
  if (self.audioPlayer.isPlaying) {
    [self stopPlayback];
  } else {
    [self startPlayback];
  }
}

/**
 *  updateLabels
 */
- (void)updateLabels {
  NSString *(^stringFromTimeInterval)(NSTimeInterval, NSString *) = ^NSString *(NSTimeInterval interval, NSString *prefix) {
    NSInteger integerInterval = (NSInteger)interval;
    NSInteger seconds = integerInterval % 60;
    NSInteger minutes = (integerInterval / 60) % 60;
    NSInteger hours = (integerInterval / 3600);

    if (hours > 0) {
      return [NSString stringWithFormat:@"%@%02ld:%02ld:%02ld", prefix, (long)hours, (long)minutes, (long)seconds];
    }
    
    return [NSString stringWithFormat:@"%@%02ld:%02ld", prefix, (long)minutes, (long)seconds];
  };
  
  self.currentTimeLabel.text = stringFromTimeInterval(self.audioPlayer.currentTime, @"");
  self.timeRemainingLabel.text = stringFromTimeInterval(self.audioPlayer.duration - self.audioPlayer.currentTime, @"–");
}

/**
 *  updateSlider
 */
- (void)updateSlider {
  self.slider.value = (self.audioPlayer.currentTime / self.audioPlayer.duration);
}

/**
 *  updatePlayButton
 */
- (void)updatePlayButton {
  self.playButton.selected = self.audioPlayer.isPlaying;
}

@end
