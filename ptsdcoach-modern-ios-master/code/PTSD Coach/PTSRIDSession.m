//
//  PTSRIDSession.m
//  PTSD Coach
//

#import "PTSRIDSession.h"

#pragma mark - Implementation

@implementation PTSRIDSession

#pragma mark - Lifecycle

/**
 *  initWithCoder
 */
- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [self init];
  if (self) {
    _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    _triggeringCauseResponse = [coder decodeObjectOfClass:[NSString class] forKey:@"triggeringCause"];
    _situationExperienceResponse = [coder decodeObjectOfClass:[NSString class] forKey:@"situationExperience"];
    _decisionResponse = [coder decodeObjectOfClass:[NSString class] forKey:@"decision"];
  }
  
  return self;
}

/**
 *  encodeWithCoder
 */
- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.date forKey:@"date"];
  [coder encodeObject:self.triggeringCauseResponse forKey:@"triggeringCause"];
  [coder encodeObject:self.situationExperienceResponse forKey:@"situationExperience"];
  [coder encodeObject:self.decisionResponse forKey:@"decision"];
}

@end
