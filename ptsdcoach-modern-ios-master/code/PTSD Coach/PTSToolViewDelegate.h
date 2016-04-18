//
//  PTSToolViewDelegate.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSTool;
@class PTSTherapySession;

@protocol PTSToolViewDelegate <NSObject>

@optional

- (void)setTool:(PTSTool *)tool;
- (void)setTherapySession:(PTSTherapySession *)therapySession;

- (void)refreshToolIfPossible;
- (void)displayNewToolIfPossible;

- (BOOL)wantsClosedCaptioningButtonInToolbar;
- (BOOL)wantsToolbarHidden;
- (BOOL)wantsToolRefreshButtonInToolbar;
- (BOOL)wantsUnwindToRerateDistressButton;
- (BOOL)wantsDismissButton;
- (BOOL)wantsFadeTransition;

- (UIBarButtonItem *)barButtonItemForRightNavigationItem;

@end
