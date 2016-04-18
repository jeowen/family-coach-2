//
//  PTSReminderManager.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PTSReminderRepeatInterval) {
  PTSReminderRepeatIntervalNever = 0,
  PTSReminderRepeatIntervalDaily = 10,
  PTSReminderRepeatIntervalWeekly = 20,
  PTSReminderRepeatIntervalBiWeekly = 30,
  PTSReminderRepeatIntervalMonthly = 40,
  PTSReminderRepeatIntervalTriMonthly = 50
};

@interface PTSReminderManager : NSObject<NSCoding>

// Public Properties
@property(nonatomic, strong) NSDate *assessmentReminderDate;
@property(nonatomic, assign) PTSReminderRepeatInterval assessmentReminderRepeatInterval;
@property(nonatomic, assign, getter = isAssessmentReminderEnabled) BOOL assessmentReminderEnabled;

@property(nonatomic, strong) NSDate *inspiringQuoteNotificationDate;
@property(nonatomic, assign, readonly) PTSReminderRepeatInterval inspiringQuoteRepeatInterval;
@property(nonatomic, assign, getter = isInspiringQuoteNotificationEnabled) BOOL inspiringQuoteNotificationEnabled;

@end
