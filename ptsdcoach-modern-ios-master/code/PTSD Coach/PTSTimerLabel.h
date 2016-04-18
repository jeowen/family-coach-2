//
//  PTSTimerLabel.h
//  PTSD Coach
//

#import "PTSDynamicTypeLabel.h"

@class PTSTimerLabel;

typedef void (^PTSTimerLabelTappedCallback)(PTSTimerLabel *);

@interface PTSTimerLabel : PTSDynamicTypeLabel

// Public Properties
@property(nonatomic, strong) PTSTimerLabelTappedCallback tappedCallbackBlock;

@end
