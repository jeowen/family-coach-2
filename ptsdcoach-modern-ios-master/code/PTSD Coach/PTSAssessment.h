//
//  PTSAssessment.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSAssessmentSession;

@interface PTSAssessment : NSObject<NSCoding>

// Public Properties
#warning Remove read-write accessors from PTSAssessment

@property(nonatomic, strong, readwrite) NSDate *date;
@property(nonatomic, assign, readwrite) NSInteger score;

// Initializers
- (instancetype)initWithAssessmentSession:(PTSAssessmentSession *)assessmentSession;

@end
