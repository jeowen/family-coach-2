//
//  PTSRandomContentProvider.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@interface PTSRandomContentProvider : NSObject

// Public Properties
@property(nonatomic, assign, getter = shouldAutomaticallyResetAfterLastItem) BOOL automaticallyResetAfterLastItem;

// Public Properties
@property(nonatomic, assign, readonly) NSInteger itemCount;
@property(nonatomic, strong, readonly) NSArray *contentItems;

// Initializers
- (instancetype)initWithContentItems:(NSArray *)contentItems;

// Public Methods
- (id)nextContentItem;
- (void)reset;

@end
