//
//  PTSToolManager.m
//  PTSD Coach
//

#import "PTSToolManager.h"
#import "PTSTool.h"

#pragma mark - Private Interface

@interface PTSToolManager()

@property(nonatomic, strong) NSArray *tools;

@end

#pragma mark - Implementation

@implementation PTSToolManager

#pragma mark - Class Methods

/**
 *  sharedToolManager
 */
+ (instancetype)sharedToolManager {
  static PTSToolManager *sSharedToolManager;
  static dispatch_once_t sSharedToolManagerOnceToken;
  
  dispatch_once(&sSharedToolManagerOnceToken, ^{
    sSharedToolManager = [[PTSToolManager alloc] init];
  });
  
  return sSharedToolManager;
}

#pragma mark - Lifecycle

/**
 *  init
 */
- (instancetype)init {
  self = [super init];
  if (self) {
    [self loadTools];
  }
  
  return self;
}

#pragma mark - Public Properties

/**
 *  userTools
 */
- (NSArray<PTSTool *> *)userTools {
  return @[];
}

/**
 *  favoriteTools
 */
- (NSArray<PTSTool *> *)favoriteTools {
  return @[];
}

/**
 *  rejectedTools
 */
- (NSArray<PTSTool *> *)rejectedTools {
  return @[];
}

/**
 *  standardTools
 */
- (NSArray<PTSTool *> *)standardTools {
  return self.tools;
}

#pragma mark - Private Methods

/**
 *  loadTools
 */
- (void)loadTools {
  NSMutableArray *mutableTools = [[NSMutableArray alloc] init];

  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierAmbientSounds]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierChangeYourPerspective]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierConnectWithOthers]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierDeepBreathing]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierGrounding]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierHelpFallingAsleep]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierInspiringQuotes]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierLeisureTimeAlone]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierLeisureInTown]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierLeisureInNature]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierMindfulnessBreathing]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierMindfulnessEating]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierMindfulnessListening]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierMindfulnessLooking]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierMindfulnessWalking]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierObserveEmotionalDiscomfort]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierObserveSensationsBodyScan]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierObserveThoughtsCloudsInSky]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierObserveThoughtsLeavesOnStream]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierMuscleRelaxation]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierPositiveImageryBeach]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierPositiveImageryCountryRoad]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierPositiveImageryForest]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierSoothingAudio]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierSoothingImages]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierRID]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierSootheSenses]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierThoughtStopping]];
  [mutableTools addObject:[PTSTool toolWithIdentifier:PTSToolIdentifierTimeOut]];

  self.tools = [mutableTools copy];
}

@end
