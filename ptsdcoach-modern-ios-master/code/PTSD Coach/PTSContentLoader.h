//
//  PTSContentLoader.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@interface PTSContentLoader : NSObject

// Public Properties
@property(nonatomic, strong, readonly) NSAttributedString *attributedString;
@property(nonatomic, strong, readonly) NSString *plainString;

// Class Methods
+ (instancetype)contentLoaderWithFilename:(NSString *)filename;
+ (instancetype)contentLoaderWithURL:(NSURL *)URL;

@end
