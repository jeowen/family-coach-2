//
//  PTSAssessment.m
//  PTSD Coach
//

#import "PTSAssessment.h"
#import "PTSAssessmentAnswer.h"
#import "PTSAssessmentQuestion.h"
#import "PTSAssessmentSession.h"

#pragma mark - Implementation

@implementation PTSAssessment

#pragma mark - Lifecycle

/**
 *  initWithAssessmentSession
 */
- (instancetype)initWithAssessmentSession:(PTSAssessmentSession *)assessmentSession {
  NSParameterAssert(assessmentSession);
  
  self = [super init];
  if (self) {
    _date = [[NSDate alloc] init];
    _score = 0;
    
    for (PTSAssessmentQuestion *question in assessmentSession.questions) {
      NSAssert(question.selectedAnswer != nil, @"Assessment question is missing selected answer.");
      
      _score += question.selectedAnswer.pointValue;
    }
  }
  
  return self;
}

/**
 *  initWithCoder
 */
- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [self init];
  if (self) {
    _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    _score = [coder decodeIntegerForKey:@"score"];
  }
  
  return self;
}

/**
 *  encodeWithCoder
 */
- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.date forKey:@"date"];
  [coder encodeInteger:self.score forKey:@"score"];
}

@end
