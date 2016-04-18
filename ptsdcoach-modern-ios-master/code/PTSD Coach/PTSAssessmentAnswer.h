//
//  PTSAssessmentAnswer.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@interface PTSAssessmentAnswer : NSObject

// Public Properties
@property(nonatomic, strong, readonly) NSString *text;
@property(nonatomic, assign, readonly) NSInteger pointValue;

// Initializers
- (instancetype)initWithText:(NSString *)text pointValue:(NSInteger)pointValue;

@end
