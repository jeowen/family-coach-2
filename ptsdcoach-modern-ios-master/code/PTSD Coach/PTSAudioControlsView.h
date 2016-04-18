//
//  PTSAudioControlsView.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

@class AVAudioPlayer;
@class PTSTimer;

typedef void (^PTSAudioControlsTimerSyncCallbackBlock)(AVAudioPlayer *);

IB_DESIGNABLE
@interface PTSAudioControlsView : UIView

// Public Properties
@property(nonatomic, assign, readonly) NSTimeInterval audioDuration;

@property(nonatomic, assign) IBInspectable BOOL wantsSeparator;
@property(nonatomic, strong) IBInspectable UIColor *separatorColor;

@property(nonatomic, strong) PTSAudioControlsTimerSyncCallbackBlock timerSyncCallbackBlock;

// Public Methods
- (void)loadAudioFileWithURL:(NSURL *)URL autoplay:(BOOL)autoplay;
- (void)startPlayback;

@end
