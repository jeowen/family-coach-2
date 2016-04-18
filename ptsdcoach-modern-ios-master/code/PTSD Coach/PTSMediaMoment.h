//
//  PTSMediaMoment.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@interface PTSMediaMoment : NSObject

// Public Properties
@property(nonatomic, strong) id userInfo;
@property(nonatomic, assign, readonly) NSTimeInterval time;
@property(nonatomic, assign, readonly) NSTimeInterval duration;

// Initializers
- (instancetype)initWithTime:(NSTimeInterval)time;
- (instancetype)initWithTime:(NSTimeInterval)time userInfo:(id)userInfo;
- (instancetype)initWithTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (instancetype)initWithTime:(NSTimeInterval)time duration:(NSTimeInterval)duration userInfo:(id)userInfo;

// Public Methods
- (BOOL)containsTime:(NSTimeInterval)time;

@end
