//
//  PTSRandomContentProvider.m
//  PTSD Coach
//

#import "PTSRandomContentProvider.h"

#pragma mark - Private Interface

@interface PTSRandomContentProvider()

@property(nonatomic, strong, readwrite) NSArray *contentItems;
@property(nonatomic, strong) NSMutableArray *availableIndexes;

@end

#pragma mark - Implementation

@implementation PTSRandomContentProvider

#pragma mark - Lifecycle

/**
 *  initWithContentItems
 */
- (instancetype)initWithContentItems:(NSArray *)contentItems {
  self = [self init];
  if (self) {
    _contentItems = contentItems;
    _automaticallyResetAfterLastItem = YES;
    
    if (!_contentItems) {
      _contentItems = @[];
    }
    
    [self reset];
  }
  
  return self;
}

#pragma mark - Public Properties

/**
 *  itemCount
 */
- (NSInteger)itemCount {
  return self.contentItems.count;
}

#pragma mark - Public Methods

/**
 *  nextContentItem
 */
- (id)nextContentItem {
  if (self.contentItems.count == 0) {
    return nil;
  }
  
  if (self.availableIndexes.count == 0) {
    if (!self.shouldAutomaticallyResetAfterLastItem) {
      return nil;
    }
    
    [self reset];
  }

  // Randomly pick an index into the available indexes array.
  u_int32_t index = arc4random_uniform((u_int32_t)(self.availableIndexes.count - 1));
  
  // Grab the content index from the randomly choses available indexes array.
  NSUInteger contentIndex = [self.availableIndexes[index] integerValue];
  [self.availableIndexes removeObjectAtIndex:index];
  
  return self.contentItems[contentIndex];
}

/**
 *  reset
 */
- (void)reset {
  self.availableIndexes = [[NSMutableArray alloc] init];
  
  for (NSInteger index = 0; index < self.contentItems.count; index++) {
    [self.availableIndexes addObject:@(index)];
  }
}

@end
