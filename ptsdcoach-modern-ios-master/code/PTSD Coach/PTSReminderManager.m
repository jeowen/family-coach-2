//
//  PTSReminderManager.m
//  PTSD Coach
//

#import "PTSReminderManager.h"

#pragma mark - Private Interface

@interface PTSReminderManager()

@end

#pragma mark - Implementation

@implementation PTSReminderManager

#pragma mark - Lifecycle

/**
 *  init
 */
- (instancetype)init {
  self = [super init];
  if (self) {
    _assessmentReminderEnabled = NO;
    _assessmentReminderRepeatInterval = PTSReminderRepeatIntervalNever;

    _inspiringQuoteNotificationEnabled = NO;
    _inspiringQuoteRepeatInterval = PTSReminderRepeatIntervalDaily;
  }
  
  return self;
}

/**
 *  initWithCoder
 */
- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [self init];
  if (self) {
    _assessmentReminderEnabled = [coder decodeBoolForKey:@"assessmentReminderEnabled"];
    _assessmentReminderDate = [coder decodeObjectForKey:@"assessmentReminderDate"];
    _assessmentReminderRepeatInterval = [coder decodeIntegerForKey:@"assessmentReminderRepeatInterval"];
    
    _inspiringQuoteNotificationEnabled = [coder decodeBoolForKey:@"inspiringQuoteNotificationEnabled"];
    _inspiringQuoteNotificationDate = [coder decodeObjectForKey:@"inspiringQuoteNotificationDate"];
  }
  
  return self;
}

/**
 *  encodeWithCoder
 */
- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeBool:self.isAssessmentReminderEnabled forKey:@"assessmentReminderEnabled"];
  [coder encodeObject:self.assessmentReminderDate forKey:@"assessmentReminderDate"];
  [coder encodeInteger:self.assessmentReminderRepeatInterval forKey:@"assessmentReminderRepeatInterval"];
  
  [coder encodeBool:self.isInspiringQuoteNotificationEnabled forKey:@"inspiringQuoteNotificationEnabled"];
  [coder encodeObject:self.inspiringQuoteNotificationDate forKey:@"inspiringQuoteNotificationDate"];
}

#pragma mark - Public Properties


@end
