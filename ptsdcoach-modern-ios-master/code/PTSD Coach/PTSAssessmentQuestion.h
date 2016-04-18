//
//  PTSAssessmentQuestion.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSAssessmentAnswer;

@interface PTSAssessmentQuestion : NSObject

// Public Properties
@property(nonatomic, strong, readonly) NSArray<PTSAssessmentAnswer *> *availableAnswers;
@property(nonatomic, strong, readonly) NSString *text;

@property(nonatomic, strong) PTSAssessmentAnswer *selectedAnswer;

// Initializers
- (instancetype)initWithText:(NSString *)text availableAnswers:(NSArray<PTSAssessmentAnswer *>*)availableAnswers;

@end
