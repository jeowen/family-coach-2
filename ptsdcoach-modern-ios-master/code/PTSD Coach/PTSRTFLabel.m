//
//  PTSRTFLabel.m
//  PTSD Coach
//

#import "PTSRTFLabel.h"

#pragma mark - Implementation

@implementation PTSRTFLabel

#pragma mark - Accessibility Methods

/**
 *  accessibilityLabel
 */
- (NSString *)accessibilityLabel {
  return (id)self.attributedText;
}

@end
