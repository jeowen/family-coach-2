//
//  PTSTimer.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSTimer;

typedef void (^PTSTimerCallbackBlock)(PTSTimer *);

@interface PTSTimer : NSObject

// Public Properties
@property(nonatomic, assign, readonly) NSTimeInterval elapsedTime;
@property(nonatomic, assign, readonly) NSTimeInterval timeRemaining;

@property(nonatomic, strong, readonly) NSString *durationStringValue;
@property(nonatomic, strong, readonly) NSString *timeRemainingStringValue;
@property(nonatomic, assign, readonly, getter = isRunning) BOOL running;

@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, assign) NSTimeInterval firingInterval;
@property(nonatomic, strong) PTSTimerCallbackBlock callbackBlock;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDateComponentsFormatter *dateComponentsFormatter;

// Class Methods
+ (instancetype)infinityTimer;
+ (void)performBlockAfterDelay:(NSTimeInterval)delay block:(void (^)())block;

// Initializers
- (instancetype)initWithDuration:(NSTimeInterval)duration;

// Public Methods
- (void)start;
- (void)stop;
- (void)reset;

@end
