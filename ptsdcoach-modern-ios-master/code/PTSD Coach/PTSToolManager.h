//
//  PTSToolManager.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSTool;

@interface PTSToolManager : NSObject

// Public Properties
@property(nonatomic, strong, readonly) NSArray<PTSTool *> *userTools;
@property(nonatomic, strong, readonly) NSArray<PTSTool *> *favoriteTools;
@property(nonatomic, strong, readonly) NSArray<PTSTool *> *rejectedTools;
@property(nonatomic, strong, readonly) NSArray<PTSTool *> *standardTools;

// Class Methods
+ (instancetype)sharedToolManager;

@end
