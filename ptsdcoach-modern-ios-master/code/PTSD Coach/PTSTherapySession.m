//
//  PTSTherapySession.m
//  PTSD Coach
//

#import "PTSTherapySession.h"
#import "PTSRandomContentProvider.h"
#import "PTSSymptom.h"
#import "PTSTool.h"
#import "PTSToolViewDelegate.h"

#pragma mark - Private Interface

@interface PTSTherapySession()

@property(nonatomic, assign, readwrite) BOOL hasRecordedInitialDistressLevel;
@property(nonatomic, strong, readwrite) PTSTool *currentTool;

@property(nonatomic, strong) PTSRandomContentProvider *randomToolPicker;

@end

#pragma mark - Implementation

@implementation PTSTherapySession

#pragma mark - Lifecycle

/**
 *  initWithContext
 */
- (instancetype)initWithContext:(PTSTherapySessionContext)context {
  self = [self init];
  if (self) {
    _distressLevel = -1;
    _context = context;
  }
  
  return self;
}

/**
 *  initWithInitiatingSymptom
 */
- (instancetype)initWithInitiatingSymptom:(PTSSymptom *)symptom {
  NSParameterAssert(symptom != nil);
  
  self = [self initWithContext:PTSTherapySessionContextSymptom];
  if (self) {
    _initiatingSymptom = symptom;
    _randomToolPicker = [[PTSRandomContentProvider alloc] initWithContentItems:symptom.tools];
    _currentTool = [_randomToolPicker nextContentItem];
  }
  
  return self;
}

/**
 *  initWithInitiatingTool
 */
- (instancetype)initWithInitiatingTool:(PTSTool *)tool {
  NSParameterAssert(tool != nil);
  
  self = [self initWithContext:PTSTherapySessionContextTool];
  if (self) {
    _initiatingTool = tool;
    _currentTool = tool;
  }
  
  return self;
}

#pragma mark - Public Properties

/**
 *  setDistressLevel
 */
- (void)setDistressLevel:(NSInteger)distressLevel {
  NSParameterAssert(distressLevel >= 0);
  NSParameterAssert(distressLevel <= 10);
  
  // If a previous distress level has been recorded, then determine the outcome.
  if (_hasRecordedInitialDistressLevel) {
    if (distressLevel > _distressLevel) {
      _distressOutcome = PTSTherapySessionDistressOutcomeIncreased;
    } else if (distressLevel < _distressLevel) {
      _distressOutcome = PTSTherapySessionDistressOutcomeDecreased;
    } else {
      _distressOutcome = PTSTherapySessionDistressOutcomeUnchanged;
    }
  } else {
    _distressOutcome = PTSTherapySessionDistressOutcomeIncomplete;
  }
  
  _hasRecordedInitialDistressLevel = YES;
  _distressLevel = distressLevel;
}

#pragma mark - Public Methods

/**
 *  prescribeNewTool
 */
- (void)prescribeNewTool {
  NSAssert(self.context == PTSTherapySessionContextSymptom, @"Therapy session should only prescribe new tools when the context is symptoms.");
  self.currentTool = [self.randomToolPicker nextContentItem];
}

/**
 *  instantiateViewControllerForCurrentTool
 */
- (UIViewController *)instantiateViewControllerForCurrentTool {
  NSAssert(self.currentTool, @"Expected currentTool to be set.");
  
  UIViewController *viewController;
  UIStoryboard *toolsStoryboard = [UIStoryboard storyboardWithName:@"PTSToolsStoryboard" bundle:nil];
  
  switch (self.currentTool.identifier) {
    case PTSToolIdentifierAmbientSounds: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"AmbientSoundsSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierChangeYourPerspective:
    case PTSToolIdentifierConnectWithOthers:
    case PTSToolIdentifierGrounding:
    case PTSToolIdentifierHelpFallingAsleep:
    case PTSToolIdentifierInspiringQuotes:
    case PTSToolIdentifierLeisureInNature:
    case PTSToolIdentifierLeisureInTown:
    case PTSToolIdentifierLeisureTimeAlone:
    case PTSToolIdentifierSootheSenses: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"TextualContentSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierMindfulnessBreathing:
    case PTSToolIdentifierMindfulnessEating:
    case PTSToolIdentifierMindfulnessWalking:
    case PTSToolIdentifierObserveEmotionalDiscomfort:
    case PTSToolIdentifierObserveSensationsBodyScan:
    case PTSToolIdentifierObserveThoughtsCloudsInSky:
    case PTSToolIdentifierObserveThoughtsLeavesOnStream:
    case PTSToolIdentifierPositiveImageryBeach:
    case PTSToolIdentifierPositiveImageryCountryRoad:
    case PTSToolIdentifierPositiveImageryForest: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"AudioExerciseIntroSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierThoughtStopping:
    case PTSToolIdentifierTimeOut: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"CountdownTipSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierRID: {
      UIStoryboard *RIDStorybord = [UIStoryboard storyboardWithName:@"PTSToolRIDStoryboard" bundle:nil];
      viewController = [RIDStorybord instantiateInitialViewController];
      break;
    }
      
#if 0
    case PTSToolIdentifierConnectWithOthers: {
      // The Connect With Others tool was originally intended to show a tip, title and an embedded
      // contact list. However, the embedded contact list is no longer needed (at least for now),
      // so this tool is now just a tip tool and can use the textualContent scene instead.s
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"ConnectOthersSceneIdentifier"];
      break;
    }
#endif
      
    case PTSToolIdentifierDeepBreathing: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"DeepBreathingIntroSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierMuscleRelaxation: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"MuscleRelaxationIntroSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierMindfulnessLooking: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"MindfulLookingIntroSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierMindfulnessListening: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"MindfulListeningSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierSoothingAudio: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"SoothingAudioSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierSoothingImages: {
      viewController = [toolsStoryboard instantiateViewControllerWithIdentifier:@"SoothingPicturesSceneIdentifier"];
      break;
    }
      
    case PTSToolIdentifierCustom: {
      // TODO: Implement this...
      break;
    }
      
    case PTSToolIdentifierUnknown: {
      NSAssert(FALSE, @"Unknown tool identifier in tool host view.");
      break;
    }
  }
  
  // We should have a tool view controller for every tool.
  if (!viewController) {
    NSAssert(FALSE, @"Missing view controller for tool in host view controller.");
    return nil;
  }
  
  if ([viewController respondsToSelector:@selector(setTherapySession:)]) {
    [viewController performSelector:@selector(setTherapySession:) withObject:self];
  }
  
  if ([viewController respondsToSelector:@selector(setTool:)]) {
    [viewController performSelector:@selector(setTool:) withObject:self.currentTool];
  }
  
  return viewController;
}

@end
