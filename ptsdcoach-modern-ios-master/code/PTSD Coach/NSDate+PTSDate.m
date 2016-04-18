//
//  NSDate+PTSDate.m
//  PTSD Coach
//

#import "NSDate+PTSDate.h"

@implementation NSDate (PTSDate)

+ (NSDate *) generateRandomDateWithinDaysBeforeToday:(NSInteger)days
{
  int r1 = arc4random_uniform(days);
  int r2 = arc4random_uniform(23);
  int r3 = arc4random_uniform(59);
  
  NSDate *today = [NSDate new];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  
  NSDateComponents *offsetComponents = [NSDateComponents new];
  [offsetComponents setDay:(r1*-1)];
  [offsetComponents setHour:r2];
  [offsetComponents setMinute:r3];
  
  NSDate *rndDate1 = [gregorian dateByAddingComponents:offsetComponents
                                                toDate:today options:0];
  
  return rndDate1;
}
@end
