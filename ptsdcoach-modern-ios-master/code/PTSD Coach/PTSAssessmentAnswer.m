//
//  PTSAssessmentAnswer.m
//  PTSD Coach
//

#import "PTSAssessmentAnswer.h"

#pragma mark - Implementation

@implementation PTSAssessmentAnswer

#pragma mark - Lifecycle

/**
 *  initWithText:pointValue
 */
- (instancetype)initWithText:(NSString *)text pointValue:(NSInteger)pointValue {
  NSParameterAssert(text);
  
  self = [super init];
  if (self) {
    _text = text;
    _pointValue = pointValue;
  }
  
  return self;
}

@end
