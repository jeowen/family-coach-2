//
//  PTSMediaCoordinator.m
//  PTSD Coach
//

#import "PTSMediaCoordinator.h"
#import "PTSMediaMoment.h"

#pragma mark - Private Interface

@interface PTSMediaCoordinator()

@property(nonatomic, strong, readwrite) NSArray *mediaMoments;
@property(nonatomic, strong) PTSMediaMoment *lastMediaMoment;

@end

#pragma mark - Implementation

@implementation PTSMediaCoordinator

#pragma mark - Class Methods

/**
 *  mediaCoordinatorWithCaptionsFile
 */
+ (instancetype)mediaCoordinatorWithCaptionsFile:(NSURL *)URL {
  PTSMediaCoordinator *mediaCoordinator = [[PTSMediaCoordinator alloc] init];
  [mediaCoordinator makeMediaMomentsFromCaptionsFile:URL];
  
  return mediaCoordinator;
}

#pragma mark - Public Methods

/**
 *  addMediaMoment
 */
- (void)addMediaMoment:(PTSMediaMoment *)mediaMoment {
  NSParameterAssert(mediaMoment);
  
  if (mediaMoment == nil) {
    return;
  }
  
  NSMutableArray *mutableMediaMoments = [[NSMutableArray alloc] init];
  [mutableMediaMoments addObject:mediaMoment];
  [mutableMediaMoments addObjectsFromArray:self.mediaMoments];
  
  // Sort the media moments in chronological order. (Earliest to latest...)
  self.mediaMoments = [mutableMediaMoments sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    PTSMediaMoment *leftMediaMoment = (PTSMediaMoment *)obj1;
    PTSMediaMoment *rightMediaMoment = (PTSMediaMoment *)obj2;
    
    if (leftMediaMoment.time < rightMediaMoment.time) {
      return NSOrderedAscending;
    } else if (leftMediaMoment.time > rightMediaMoment.time) {
      return NSOrderedDescending;
    }
    
    return NSOrderedSame;
  }];
  
//  NSLog(@"Added Media Moment...");
//  for (PTSMediaMoment *moment in self.mediaMoments) {
//    NSLog(@"Tie: %@, Duration: %@, UserInfo: %@", @(moment.time), @(moment.duration), moment.userInfo);
//
//  }
}

/**
 *  mediaMomentForTime
 */
- (PTSMediaMoment *)mediaMomentForTime:(NSTimeInterval)time {
  PTSMediaMoment *mediaMoment;
  
  // Because the mediaMoments are organized in chronological order, we can just enumerate through
  // them in reverse to find the matching media moment, which is the first one that has a time
  // earlier than the comparison time.
  for (PTSMediaMoment *moment in self.mediaMoments.reverseObjectEnumerator) {
    if (moment.time <= time) {
      mediaMoment = moment;
      break;
    }
  }
  
  return mediaMoment;
}

/**
 *  performMediaMomentForTime:performanceBlock
 */
- (void)performMediaMomentForTime:(NSTimeInterval)time performanceBlock:(PTSMediaCoordinatorPerformanceBlock)performaceBlock {
  NSParameterAssert(performaceBlock);
  
  PTSMediaMoment *mediaMoment = [self mediaMomentForTime:time];
  
  if (mediaMoment != self.lastMediaMoment) {
    performaceBlock(mediaMoment);
    self.lastMediaMoment = mediaMoment;
  }
}

#pragma mark - Private Methods

/**
 *  makeMediaMomentsFromCaptionsFile
 */
- (void)makeMediaMomentsFromCaptionsFile:(NSURL *)URL {
  NSArray *captions = [NSArray arrayWithContentsOfURL:URL];
  
  // Converts a string like "4:15" to seconds.
  // e.x.: (4 * 60) + 15 = 255 seconds.
  NSTimeInterval (^secondsFromString)(NSString *) = ^NSTimeInterval(NSString *string) {
    NSArray *components = [string componentsSeparatedByString:@":"];
    NSTimeInterval seconds = 0.0;
    
    for (NSInteger i = 0; i < components.count; i++) {
      seconds = 60 * seconds + [components[i] integerValue];
    }

    return seconds;
  };
  
  // We expect the PList file to be an array of dictionaries. Each dictionary is a caption and
  // contains three keys: start, end, caption.
  for (NSDictionary *caption in captions) {
    
    NSString *text = caption[@"caption"];
    NSTimeInterval start = secondsFromString(caption[@"start"]);
    NSTimeInterval end = secondsFromString(caption[@"end"]);
    NSTimeInterval duration = end - start;
    
    PTSMediaMoment *mediaMoment = [[PTSMediaMoment alloc] initWithTime:start duration:duration userInfo:text];
    [self addMediaMoment:mediaMoment];
  }
}

@end
