//
//  PTSTimer.m
//  PTSD Coach
//

#import "PTSTimer.h"

#pragma mark - Private Interface

@interface PTSTimer()

@property(nonatomic, assign, readwrite, getter = isRunning) BOOL running;
@property(nonatomic, assign) NSTimeInterval runningTime;
@property(nonatomic, strong) NSDate *lastTickleDate;
@property(nonatomic, assign, getter = shouldIgnoreNextTickle) BOOL ignoreNextTickle;

@end

#pragma mark - Implementation

@implementation PTSTimer

#pragma mark - Class Methods

/**
 *  infinityTimer
 */
+ (instancetype)infinityTimer {
  return [[PTSTimer alloc] initWithDuration:DBL_MAX];
}

/**
 *  performBlockAfterDelay
 */
+ (void)performBlockAfterDelay:(NSTimeInterval)delay block:(void (^)())block {
  if (!block) {
    return;
  }
  
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
    block();
  });
}

#pragma mark - Lifecycle

/**
 *  initWithDuration
 */
- (instancetype)initWithDuration:(NSTimeInterval)duration {
  NSParameterAssert(duration >= 0);
  
  self = [self init];
  if (self) {
    _running = NO;
    _duration = duration;
    _firingInterval = 1.0 / 10.0;
    _ignoreNextTickle = NO;
  }
  
  return self;
}

/**
 *  dealloc
 */
- (void)dealloc {
  [self stop];
}

#pragma mark - Public Properties

/**
 *  setDuration
 */
- (void)setDuration:(NSTimeInterval)duration {
  [self reset];

  _duration = duration;

  if (self.callbackBlock) {
    self.callbackBlock(self);
  }
}

/**
 *  elapsedTime
 */
- (NSTimeInterval)elapsedTime {
  return self.runningTime;
}

/**
 *  timeRemaining
 */
- (NSTimeInterval)timeRemaining {
  return MAX(self.duration - self.elapsedTime, 0);
}

/**
 *  durationStringValue
 */
- (NSString *)durationStringValue {
  return [self.dateComponentsFormatter stringFromTimeInterval:self.duration];
}

/**
 *  timeRemainingStringValue
 */
- (NSString *)timeRemainingStringValue {
  return [self.dateComponentsFormatter stringFromTimeInterval:self.timeRemaining];
}

/**
 *  dateFormatter
 */
- (NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateStyle = NSDateFormatterNoStyle;
    _dateFormatter.timeStyle = NSDateFormatterShortStyle;
  }
  
  return _dateFormatter;
}

/**
 *  dateComponentsFormatter
 */
- (NSDateComponentsFormatter *)dateComponentsFormatter {
  if (!_dateComponentsFormatter) {
    _dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
    _dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
  }
  
  return _dateComponentsFormatter;
}

#pragma mark - Public Methods

/**
 *  start
 */
- (void)start {
  if (self.isRunning) {
    return;
  }
  
  self.running = YES;
  self.ignoreNextTickle = NO;
  
  [self tickle];
}

/**
 *  stop
 */
- (void)stop {
  self.running = NO;
  self.lastTickleDate = nil;
  self.ignoreNextTickle = YES;
}

/**
 *  reset
 */
- (void)reset {
  [self stop];
  
  self.runningTime = 0;
}

#pragma mark - Private Methods

/**
 *  tickle
 */
- (void)tickle {
  if (self.shouldIgnoreNextTickle) {
    return;
  }

  if (self.lastTickleDate) {
    NSDate *date = [NSDate date];
    self.runningTime += [date timeIntervalSinceDate:self.lastTickleDate];
    self.lastTickleDate = date;
  } else {
    self.lastTickleDate = [NSDate date];
  }
  
  if (self.callbackBlock) {
    self.callbackBlock(self);
  }

  // If there is no time remaining, then reset the timer.
  if (self.timeRemaining <= 0) {
    [self reset];
    
    // Give the callback another chance to run since we've changed the running state.
    if (self.callbackBlock) {
      self.callbackBlock(self);
    }
  } else {
    PTSTimer *__weak weakSelf = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.firingInterval * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [weakSelf tickle];
    });
  }
}

@end
