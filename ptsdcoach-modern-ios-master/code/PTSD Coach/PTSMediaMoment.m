//
//  PTSMediaMoment.m
//  PTSD Coach
//

#import "PTSMediaMoment.h"

#pragma mark - Implementation

@implementation PTSMediaMoment

#pragma mark - Lifecycle

/**
 *  init
 */
- (instancetype)init {
  return [self initWithTime:0 duration:0];
}

/**
 *  initWithTime
 */
- (instancetype)initWithTime:(NSTimeInterval)time {
  return [self initWithTime:time duration:DBL_MAX userInfo:nil];
}

/**
 *  initWithTime
 */
- (instancetype)initWithTime:(NSTimeInterval)time userInfo:(id)userInfo {
  return [self initWithTime:time duration:DBL_MAX userInfo:userInfo];
}

/**
 *  initwithTime:duration
 */
- (instancetype)initWithTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
  return [self initWithTime:time duration:duration userInfo:nil];
}

/**
 *  initwithTime:duration
 */
- (instancetype)initWithTime:(NSTimeInterval)time duration:(NSTimeInterval)duration userInfo:(id)userInfo {
  self = [super init];
  if (self) {
    _time = time;
    _duration = duration;
    _userInfo = userInfo;
  }
  
  return self;
}

#pragma mark - Public Methods

/**
 *  containsTime
 */
- (BOOL)containsTime:(NSTimeInterval)time {
  return (time >= self.time && time <= self.time + self.duration);
}

@end
