//
//  NSDate+PTSDate.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@interface NSDate (PTSDate)

+ (NSDate *) generateRandomDateWithinDaysBeforeToday:(NSInteger)days;

@end
