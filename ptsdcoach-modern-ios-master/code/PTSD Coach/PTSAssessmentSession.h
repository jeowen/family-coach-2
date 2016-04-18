//
//  PTSAssessmentSession.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSAssessmentQuestion;

@interface PTSAssessmentSession : NSObject

// Public Properties
@property(nonatomic, strong, readonly) NSArray<PTSAssessmentQuestion *> *questions;
@property(nonatomic, strong, readonly) PTSAssessmentQuestion *currentQuestion;
@property(nonatomic, assign, readonly) BOOL isOnFirstQuestion;
@property(nonatomic, assign, readonly) BOOL isOnLastQuestion;

@property(nonatomic, assign) NSUInteger currentQuestionIndex;

@end
