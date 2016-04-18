//
//  PTSSymptom.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSTool;

typedef NS_ENUM(NSInteger, PTSSymptomIdentifier) {
  PTSSymptomIdentifierRemindedTrauma = 1,
  PTSSymptomIdentifierAvoidingTriggers,
  PTSSymptomIdentifierDisconnectedPeople,
  PTSSymptomIdentifierDisconnectedReality,
  PTSSymptomIdentifierSadHopeless,
  PTSSymptomIdentifierWorriedAnxious,
  PTSSymptomIdentifierAngry,
  PTSSymptomIdentifierUnableSleep
};

@interface PTSSymptom : NSObject

// Public Properties
@property(nonatomic, assign, readonly) PTSSymptomIdentifier identifier;
@property(nonatomic, strong, readonly) NSArray<PTSTool *> *tools;

// Initializers
- (instancetype)initWithSymptomIdentifier:(PTSSymptomIdentifier)identifier;

@end
