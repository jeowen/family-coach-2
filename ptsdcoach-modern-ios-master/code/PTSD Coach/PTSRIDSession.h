//
//  PTSRIDSession.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@interface PTSRIDSession : NSObject<NSCoding>

// Public Properties
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSString *triggeringCauseResponse;
@property(nonatomic, strong) NSString *situationExperienceResponse;
@property(nonatomic, strong) NSString *decisionResponse;

@end
