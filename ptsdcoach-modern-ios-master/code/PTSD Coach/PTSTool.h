//
//  PTSTool.h
//  PTSD Coach
//

#import <Foundation/Foundation.h>

@class PTSSymptom;

typedef NS_ENUM(NSInteger, PTSToolIdentifier) {
  PTSToolIdentifierUnknown = 0,
  
  PTSToolIdentifierAmbientSounds,
  PTSToolIdentifierChangeYourPerspective,
  PTSToolIdentifierConnectWithOthers,
  PTSToolIdentifierDeepBreathing,
  PTSToolIdentifierGrounding,
  PTSToolIdentifierHelpFallingAsleep,
  PTSToolIdentifierInspiringQuotes,
  PTSToolIdentifierLeisureTimeAlone,
  PTSToolIdentifierLeisureInTown,
  PTSToolIdentifierLeisureInNature,
  PTSToolIdentifierMindfulnessBreathing,
  PTSToolIdentifierMindfulnessEating,
  PTSToolIdentifierMindfulnessListening,
  PTSToolIdentifierMindfulnessLooking,
  PTSToolIdentifierMindfulnessWalking,
  PTSToolIdentifierMuscleRelaxation,
  PTSToolIdentifierObserveEmotionalDiscomfort,
  PTSToolIdentifierObserveSensationsBodyScan,
  PTSToolIdentifierObserveThoughtsCloudsInSky,
  PTSToolIdentifierObserveThoughtsLeavesOnStream,
  PTSToolIdentifierPositiveImageryBeach,
  PTSToolIdentifierPositiveImageryCountryRoad,
  PTSToolIdentifierPositiveImageryForest,
  PTSToolIdentifierSoothingAudio,
  PTSToolIdentifierSoothingImages,
  PTSToolIdentifierRID,
  PTSToolIdentifierSootheSenses,
  PTSToolIdentifierThoughtStopping,
  PTSToolIdentifierTimeOut,
  
  PTSToolIdentifierCustom = 10000
};

typedef NS_ENUM(NSInteger, PTSToolCustomToolType) {
  PTSToolCustomToolTypeText,
  PTSToolCustomToolTypeMemo,
  PTSToolCustomToolTypePhoto,
  PTSToolCustomToolTypeMusic,
  PTSToolCustomToolTypeVideo
};

typedef NS_ENUM(NSInteger, PTSToolLikeability) {
  PTSToolLikeabilityNeutral = 0,
  PTSToolLikeabilityPositive,
  PTSToolLikeabilityNegative
};

@interface PTSTool : NSObject

// Public Properties
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) PTSToolLikeability likeability;

// Not all properties are applicable to all tools. Some of the URL
// properties below are specific to certain tool identifiers.
@property(nonatomic, strong) NSURL *audioURL;
@property(nonatomic, strong) NSURL *captionsURL;
@property(nonatomic, strong) NSURL *contentURL;
@property(nonatomic, strong) NSURL *selfGuidedContentURL;
@property(nonatomic, strong) NSURL *audioExerciseIntroURL;
@property(nonatomic, strong) NSString *audioExerciseImageName;

@property(nonatomic, assign, readonly) PTSToolIdentifier identifier;
@property(nonatomic, assign) PTSToolCustomToolType customToolType;

// Class Methods
+ (instancetype)toolWithIdentifier:(PTSToolIdentifier)identifier;

// Public Methods
- (NSURL *)contentURLWithSymptom:(PTSSymptom *)symptom;

@end
