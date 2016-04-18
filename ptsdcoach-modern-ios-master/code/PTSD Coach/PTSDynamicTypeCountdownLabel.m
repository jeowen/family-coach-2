//
//  PTSDynamicTypeCountdownLabel.m
//  PTSD Coach
//

#import "PTSDynamicTypeCountdownLabel.h"

#pragma mark - Implementation

@implementation PTSDynamicTypeCountdownLabel

#pragma mark - Public Properties

/**
 *  fontDescriptor
 */
- (UIFontDescriptor *)fontDescriptor {
  UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleTitle2];
  UIFont *monospacedFont = [UIFont monospacedDigitSystemFontOfSize:fontDescriptor.pointSize weight:UIFontWeightRegular];

  return monospacedFont.fontDescriptor;
}

@end
