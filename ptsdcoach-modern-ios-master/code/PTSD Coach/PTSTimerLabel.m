//
//  PTSTimerLabel.m
//  PTSD Coach
//

#import "PTSTimerLabel.h"

#pragma mark - Private Interface

@interface PTSTimerLabel()

@property(nonatomic, assign) BOOL didAddTapGesture;

@end

#pragma mark - Implementation

@implementation PTSTimerLabel

#pragma mark - Public Properties

/**
 *  setTappedCallbackBlock
 */
- (void)setTappedCallbackBlock:(PTSTimerLabelTappedCallback)tappedCallbackBlock {
  _tappedCallbackBlock = tappedCallbackBlock;
  
  if (!self.didAddTapGesture) {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    self.userInteractionEnabled = YES;
    self.didAddTapGesture = YES;
  }
}

#pragma mark - Action Methods

/**
 *  handleTapGesture
 */
- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
  if (self.tappedCallbackBlock) {
    self.tappedCallbackBlock(self);
  }
}

#pragma mark - PTSDynamicTypeLabel Methods

/**
 *  fontDescriptor
 */
- (UIFontDescriptor *)fontDescriptor {
  UIFontDescriptor *preferredFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleTitle2];
  UIFont *digitsFont = [UIFont monospacedDigitSystemFontOfSize:preferredFontDescriptor.pointSize weight:UIFontWeightRegular];
  
  return [digitsFont fontDescriptor];
}

@end
