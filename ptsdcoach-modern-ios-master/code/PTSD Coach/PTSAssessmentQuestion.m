//
//  PTSAssessmentQuestion.m
//  PTSD Coach
//

#import "PTSAssessmentQuestion.h"

#pragma mark - Implementation

@implementation PTSAssessmentQuestion

#pragma mark - Lifecycle

/**
 *  initWithText
 */
- (instancetype)initWithText:(NSString *)text availableAnswers:(NSArray<PTSAssessmentAnswer *>*)availableAnswers {
  NSParameterAssert(text);
  NSParameterAssert(availableAnswers.count > 0);
  
  self = [super init];
  if (self) {
    _text = text;
    _availableAnswers = availableAnswers;
  }
  
  return self;
}

@end
