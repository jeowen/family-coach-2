//
//  PTSMediaCoordinator.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSMediaMoment;

typedef void (^PTSMediaCoordinatorPerformanceBlock)(PTSMediaMoment *mediaMoment);

@interface PTSMediaCoordinator : NSObject

// Public Properties
@property(nonatomic, strong, readonly) NSArray *mediaMoments;

// Initializers
+ (instancetype)mediaCoordinatorWithCaptionsFile:(NSURL *)URL;

// Public Methods
- (void)addMediaMoment:(PTSMediaMoment *)mediaMoment;
- (PTSMediaMoment *)mediaMomentForTime:(NSTimeInterval)time;
- (void)performMediaMomentForTime:(NSTimeInterval)time performanceBlock:(PTSMediaCoordinatorPerformanceBlock)performaceBlock;

@end
