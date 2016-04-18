//
//  PTSSymptom.m
//  PTSD Coach
//

#import "PTSSymptom.h"
#import "PTSTool.h"
#import "PTSToolManager.h"

#pragma mark - Private Interface

@interface PTSSymptom()

@property(nonatomic, strong, readwrite) NSArray<PTSTool *> *tools;

@end

#pragma mark - Implementation 

@implementation PTSSymptom

#pragma mark - Lifecycle

/**
 *  initWithSymptomIdentifier
 */
- (instancetype)initWithSymptomIdentifier:(PTSSymptomIdentifier)identifier {
  self = [self init];
  if (self) {
    _identifier = identifier;
  }
  
  return self;
}

#pragma mark - Public Properties

/**
 *  tools
 */
- (NSArray<PTSTool *> *)tools {
  if (!_tools) {
    
    NSArray *(^toolsWithIdentifiers)(NSArray *) = ^NSArray *(NSArray *toolIdentifiers) {
      PTSToolManager *toolManager = [PTSToolManager sharedToolManager];
      NSMutableArray *mutableTools = [[NSMutableArray alloc] init];

      for (PTSTool *tool in toolManager.standardTools) {
        if ([toolIdentifiers containsObject:@(tool.identifier)]) {
          [mutableTools addObject:tool];
        }
      }
      
      NSAssert(mutableTools.count == toolIdentifiers.count, @"Missing tool for identifier.");
      
      return [mutableTools copy];
    };

    switch (_identifier) {
      case PTSSymptomIdentifierRemindedTrauma: {
        _tools = toolsWithIdentifiers(@[@(PTSToolIdentifierAmbientSounds),
                                        @(PTSToolIdentifierChangeYourPerspective),
                                        @(PTSToolIdentifierDeepBreathing),
                                        @(PTSToolIdentifierGrounding),
                                        @(PTSToolIdentifierInspiringQuotes),
                                        @(PTSToolIdentifierLeisureTimeAlone),
                                        @(PTSToolIdentifierLeisureInTown),
                                        @(PTSToolIdentifierLeisureInNature),
                                        @(PTSToolIdentifierMindfulnessBreathing),
                                        @(PTSToolIdentifierMindfulnessEating),
                                        @(PTSToolIdentifierMindfulnessListening),
                                        @(PTSToolIdentifierMindfulnessLooking),
                                        @(PTSToolIdentifierMindfulnessWalking),
                                        @(PTSToolIdentifierObserveSensationsBodyScan),
                                        @(PTSToolIdentifierObserveThoughtsCloudsInSky),
                                        @(PTSToolIdentifierObserveThoughtsLeavesOnStream),
                                        @(PTSToolIdentifierMuscleRelaxation),
                                        @(PTSToolIdentifierPositiveImageryBeach),
                                        @(PTSToolIdentifierPositiveImageryCountryRoad),
                                        @(PTSToolIdentifierPositiveImageryForest),
                                        @(PTSToolIdentifierSoothingAudio),
                                        @(PTSToolIdentifierSoothingImages),
                                        @(PTSToolIdentifierRID),
                                        @(PTSToolIdentifierSootheSenses)]);
        break;
      }
        
      case PTSSymptomIdentifierAvoidingTriggers: {
        _tools = toolsWithIdentifiers(@[@(PTSToolIdentifierAmbientSounds),
                                        @(PTSToolIdentifierChangeYourPerspective),
                                        @(PTSToolIdentifierInspiringQuotes),
                                        @(PTSToolIdentifierDeepBreathing),
                                        @(PTSToolIdentifierMindfulnessBreathing),
                                        @(PTSToolIdentifierMindfulnessEating),
                                        @(PTSToolIdentifierMindfulnessListening),
                                        @(PTSToolIdentifierMindfulnessLooking),
                                        @(PTSToolIdentifierMindfulnessWalking),
                                        @(PTSToolIdentifierObserveSensationsBodyScan),
                                        @(PTSToolIdentifierObserveThoughtsCloudsInSky),
                                        @(PTSToolIdentifierObserveThoughtsLeavesOnStream),
                                        @(PTSToolIdentifierMuscleRelaxation),
                                        @(PTSToolIdentifierPositiveImageryBeach),
                                        @(PTSToolIdentifierPositiveImageryCountryRoad),
                                        @(PTSToolIdentifierPositiveImageryForest),
                                        @(PTSToolIdentifierSoothingAudio),
                                        @(PTSToolIdentifierSoothingImages)]);
        break;
      }
        
      case PTSSymptomIdentifierDisconnectedPeople: {
        _tools = toolsWithIdentifiers(@[@(PTSToolIdentifierChangeYourPerspective),
                                        @(PTSToolIdentifierConnectWithOthers),
                                        @(PTSToolIdentifierInspiringQuotes)]);
        break;
      }
        
      case PTSSymptomIdentifierDisconnectedReality: {
        _tools = toolsWithIdentifiers(@[@(PTSToolIdentifierAmbientSounds),
                                        @(PTSToolIdentifierChangeYourPerspective),
                                        @(PTSToolIdentifierDeepBreathing),
                                        @(PTSToolIdentifierGrounding),
                                        @(PTSToolIdentifierInspiringQuotes),
                                        @(PTSToolIdentifierMuscleRelaxation),
                                        @(PTSToolIdentifierPositiveImageryBeach),
                                        @(PTSToolIdentifierPositiveImageryCountryRoad),
                                        @(PTSToolIdentifierPositiveImageryForest),
                                        @(PTSToolIdentifierSoothingAudio),
                                        @(PTSToolIdentifierSoothingImages)]);
        break;
      }
        
      case PTSSymptomIdentifierSadHopeless: {
        _tools = toolsWithIdentifiers(@[@(PTSToolIdentifierChangeYourPerspective),
                                        @(PTSToolIdentifierConnectWithOthers),
                                        @(PTSToolIdentifierInspiringQuotes),
                                        @(PTSToolIdentifierLeisureTimeAlone),
                                        @(PTSToolIdentifierLeisureInTown),
                                        @(PTSToolIdentifierLeisureInNature),
                                        @(PTSToolIdentifierMindfulnessBreathing),
                                        @(PTSToolIdentifierMindfulnessEating),
                                        @(PTSToolIdentifierMindfulnessListening),
                                        @(PTSToolIdentifierMindfulnessLooking),
                                        @(PTSToolIdentifierMindfulnessWalking),
                                        @(PTSToolIdentifierObserveSensationsBodyScan),
                                        @(PTSToolIdentifierObserveThoughtsCloudsInSky),
                                        @(PTSToolIdentifierObserveThoughtsLeavesOnStream),
                                        @(PTSToolIdentifierSootheSenses)]);
        break;
      }
        
      case PTSSymptomIdentifierWorriedAnxious: {
        _tools = toolsWithIdentifiers(@[@(PTSToolIdentifierAmbientSounds),
                                        @(PTSToolIdentifierChangeYourPerspective),
                                        @(PTSToolIdentifierConnectWithOthers),
                                        @(PTSToolIdentifierDeepBreathing),
                                        @(PTSToolIdentifierGrounding),
                                        @(PTSToolIdentifierInspiringQuotes),
                                        @(PTSToolIdentifierLeisureTimeAlone),
                                        @(PTSToolIdentifierLeisureInTown),
                                        @(PTSToolIdentifierLeisureInNature),
                                        @(PTSToolIdentifierMindfulnessBreathing),
                                        @(PTSToolIdentifierMindfulnessEating),
                                        @(PTSToolIdentifierMindfulnessListening),
                                        @(PTSToolIdentifierMindfulnessLooking),
                                        @(PTSToolIdentifierMindfulnessWalking),
                                        @(PTSToolIdentifierObserveSensationsBodyScan),
                                        @(PTSToolIdentifierObserveThoughtsCloudsInSky),
                                        @(PTSToolIdentifierObserveThoughtsLeavesOnStream),
                                        @(PTSToolIdentifierMuscleRelaxation),
                                        @(PTSToolIdentifierPositiveImageryBeach),
                                        @(PTSToolIdentifierPositiveImageryCountryRoad),
                                        @(PTSToolIdentifierPositiveImageryForest),
                                        @(PTSToolIdentifierSoothingAudio),
                                        @(PTSToolIdentifierSoothingImages),
                                        @(PTSToolIdentifierSootheSenses)]);
        break;
      }
        
      case PTSSymptomIdentifierAngry: {
        _tools = toolsWithIdentifiers(@[@(PTSToolIdentifierAmbientSounds),
                                        @(PTSToolIdentifierChangeYourPerspective),
                                        @(PTSToolIdentifierDeepBreathing),
                                        @(PTSToolIdentifierLeisureTimeAlone),
                                        @(PTSToolIdentifierLeisureInTown),
                                        @(PTSToolIdentifierLeisureInNature),
                                        @(PTSToolIdentifierMindfulnessBreathing),
                                        @(PTSToolIdentifierMindfulnessEating),
                                        @(PTSToolIdentifierMindfulnessListening),
                                        @(PTSToolIdentifierMindfulnessLooking),
                                        @(PTSToolIdentifierMindfulnessWalking),
                                        @(PTSToolIdentifierObserveSensationsBodyScan),
                                        @(PTSToolIdentifierObserveThoughtsCloudsInSky),
                                        @(PTSToolIdentifierObserveThoughtsLeavesOnStream),
                                        @(PTSToolIdentifierMuscleRelaxation),
                                        @(PTSToolIdentifierPositiveImageryBeach),
                                        @(PTSToolIdentifierPositiveImageryCountryRoad),
                                        @(PTSToolIdentifierPositiveImageryForest),
                                        @(PTSToolIdentifierSoothingAudio),
                                        @(PTSToolIdentifierSoothingImages),
                                        @(PTSToolIdentifierSootheSenses),
                                        @(PTSToolIdentifierThoughtStopping),
                                        @(PTSToolIdentifierTimeOut)]);
        break;
      }
        
      case PTSSymptomIdentifierUnableSleep: {
        _tools = toolsWithIdentifiers(@[@(PTSToolIdentifierAmbientSounds),
                                        @(PTSToolIdentifierDeepBreathing),
                                        @(PTSToolIdentifierGrounding),
                                        @(PTSToolIdentifierHelpFallingAsleep),
                                        @(PTSToolIdentifierInspiringQuotes),
                                        @(PTSToolIdentifierMuscleRelaxation),
                                        @(PTSToolIdentifierPositiveImageryBeach),
                                        @(PTSToolIdentifierPositiveImageryCountryRoad),
                                        @(PTSToolIdentifierPositiveImageryForest),
                                        @(PTSToolIdentifierSoothingAudio),
                                        @(PTSToolIdentifierSoothingImages)]);
        break;
      }
    }
  }
  
  return _tools;
}

@end
