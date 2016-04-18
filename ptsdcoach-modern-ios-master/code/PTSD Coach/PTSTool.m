//
//  PTSTool.m
//  PTSD Coach
//

#import "PTSTool.h"
#import "PTSSymptom.h"

#pragma mark - Private Interface

@interface PTSTool()

@property(nonatomic, strong) NSDictionary *symptomSpecificContentURLs;

@end

#pragma mark - Implementation

@implementation PTSTool

/**
 *  toolWithIdentifier
 */
+ (instancetype)toolWithIdentifier:(PTSToolIdentifier)identifier {
  NSParameterAssert(identifier != PTSToolIdentifierUnknown);
  
  return [[PTSTool alloc] initWithIdentifier:identifier];
}

#pragma mark - Lifecycle

/**
 *  init
 */
- (instancetype)initWithIdentifier:(PTSToolIdentifier)identifier {
  self = [self init];
  if (self) {
    _identifier = identifier;
    _likeability = PTSToolLikeabilityNeutral;
    
    // Helper function for loading content from main bundle.
    NSURL *(^resourceURLWithFilename)(NSString *) = ^NSURL *(NSString *filename) {
      if (filename.length < 1) {
        NSLog(@"**** WARNING: Undeclared resource for tool with title: %@", self.title);
        
        return nil;
      }
      
      NSString *extension = filename.pathExtension;
      NSString *resourceName = [filename stringByDeletingPathExtension];
      NSURL *URL = [[NSBundle mainBundle] URLForResource:resourceName withExtension:extension];
      
      // All resources must be present.
      NSAssert(URL != nil, @"Missing resource with filename: %@", filename);
      
      return URL;
    };
    
    switch (identifier) {
      case PTSToolIdentifierAmbientSounds: {
        _title = NSLocalizedString(@"Ambient Sounds", nil);
        break;
      }
        
      case PTSToolIdentifierChangeYourPerspective: {
        _title = NSLocalizedString(@"Change Your Perspective", nil);
                
        _contentURL = resourceURLWithFilename(@"Tools - Change Your Perspective - All.plist");
        _symptomSpecificContentURLs = @{ @(PTSSymptomIdentifierAngry) :
                                          resourceURLWithFilename(@"Tools - Change Your Perspective - Angry.plist"),
                                         @(PTSSymptomIdentifierAvoidingTriggers) :
                                           resourceURLWithFilename(@"Tools - Change Your Perspective - Avoiding Triggers.plist"),
                                         @(PTSSymptomIdentifierDisconnectedPeople) :
                                           resourceURLWithFilename(@"Tools - Change Your Perspective - Disconnected People.plist"),
                                         @(PTSSymptomIdentifierDisconnectedReality) :
                                           resourceURLWithFilename(@"Tools - Change Your Perspective - Disconnected Reality.plist"),
                                         @(PTSSymptomIdentifierRemindedTrauma) :
                                           resourceURLWithFilename(@"Tools - Change Your Perspective - Reminded Trauma.plist"),
                                         @(PTSSymptomIdentifierSadHopeless) :
                                           resourceURLWithFilename(@"Tools - Change Your Perspective - Sad Hopeless.plist"),
                                         @(PTSSymptomIdentifierUnableSleep) :
                                           resourceURLWithFilename(@"Tools - Change Your Perspective - Unable to Sleep.plist"),
                                         @(PTSSymptomIdentifierWorriedAnxious) :
                                           resourceURLWithFilename(@"Tools - Change Your Perspective - Worried Anxious.plist") };
        
        break;
      }
        
      case PTSToolIdentifierConnectWithOthers: {
        _title = NSLocalizedString(@"Connect With Others", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Connect With Others.plist");
        
        break;
      }
        
      case PTSToolIdentifierDeepBreathing: {
        _title = NSLocalizedString(@"Deep Breathing", nil);
        _audioURL = resourceURLWithFilename(@"Audio Guide - Deep Breathing.m4a");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Deep Breathing.plist");
        
        break;
      }
        
      case PTSToolIdentifierGrounding: {
        _title = NSLocalizedString(@"Grounding", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Grounding.plist");
        
        break;
      }
        
      case PTSToolIdentifierHelpFallingAsleep: {
        _title = NSLocalizedString(@"Help Falling Asleep", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Help Falling Asleep.plist");
        
        break;
      }
        
      case PTSToolIdentifierInspiringQuotes: {
        _title = NSLocalizedString(@"Inspiring Quotes", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Inspiring Quotes.plist");
        
        break;
      }
        
      case PTSToolIdentifierLeisureTimeAlone: {
        _title = NSLocalizedString(@"Leisure: Time Alone", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Leisure Enjoy Time Alone.plist");
        
        break;
      }
        
      case PTSToolIdentifierLeisureInTown: {
        _title = NSLocalizedString(@"Leisure: In Town ", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Leisure In Town.plist");
        
        break;
      }
        
      case PTSToolIdentifierLeisureInNature: {
        _title = NSLocalizedString(@"Leisure: In Nature", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Leisure Recharge in Nature.plist");
        
        break;
      }
        
      case PTSToolIdentifierMindfulnessBreathing: {
        _title = NSLocalizedString(@"Mindfulness: Breathing", nil);
        _selfGuidedContentURL = resourceURLWithFilename(@"Tools - Mindfulness Breathing - Self Guided.rtf");
        _audioExerciseImageName = @"Tool - Mindful Breathing Audio Exercise";
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Mindfulness Breathing - Intro.rtf");
        _audioURL = resourceURLWithFilename(@"Audio Guide - Mindful Breathing.mp3");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Mindful Breathing.plist");
        
        break;
      }
        
      case PTSToolIdentifierMindfulnessEating: {
        _title = NSLocalizedString(@"Mindfulness: Eating", nil);
        _selfGuidedContentURL = resourceURLWithFilename(@"Tools - Mindfulness Eating - Self Guided.rtf");
        _audioExerciseImageName = @"Tool - Mindful Eating Audio Exercise";
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Mindfulness Eating - Intro.rtf");
        _audioURL = resourceURLWithFilename(@"Audio Guide - Mindful Eating.mp3");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Mindful Eating.plist");
        
        break;
      }
        
      case PTSToolIdentifierMindfulnessListening: {
        _title = NSLocalizedString(@"Mindfulness: Listening", nil);
        
        break;
      }
        
      case PTSToolIdentifierMindfulnessLooking: {
        _title = NSLocalizedString(@"Mindfulness: Looking", nil);
        
        break;
      }
        
      case PTSToolIdentifierMindfulnessWalking: {
        _title = NSLocalizedString(@"Mindfulness: Walking", nil);
        _selfGuidedContentURL = resourceURLWithFilename(@"Tools - Mindfulness Walking - Self Guided.rtf");
        _audioExerciseImageName = @"Tool - Mindful Walking Audio Exercise";
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Mindfulness Walking - Intro.rtf");
        _audioURL = resourceURLWithFilename(@"Audio Guide - Mindful Walking.mp3");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Mindful Walking.plist");
        
        break;
      }
        
      case PTSToolIdentifierMuscleRelaxation: {
        _title = NSLocalizedString(@"Muscle Relaxation", nil);
        _audioURL = resourceURLWithFilename(@"Audio Guide - Muscle Relaxation.m4a");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Muscle Relaxation.plist");
        
        break;
      }
        
      case PTSToolIdentifierObserveEmotionalDiscomfort: {
        _title = NSLocalizedString(@"Mindfulness: Emotions", nil);
        _selfGuidedContentURL = resourceURLWithFilename(@"Tools - Observe Emotional Discomfort - Self Guided.rtf");
        _audioExerciseImageName = @"Tool - Observe Emotional Discomfort Audio Exercise";
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Observe Emotional Discomfort - Intro.rtf");
        _audioURL = resourceURLWithFilename(@"Audio Guide - Observe Emotional Discomfort.mp3");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Observe Emotional Discomfort.plist");
        
        break;
      }
        
      case PTSToolIdentifierObserveSensationsBodyScan: {
        _title = NSLocalizedString(@"Mindfulness: Body Scan", nil);
        _selfGuidedContentURL = resourceURLWithFilename(@"Tools - Observe Sensations Body Scan - Self Guided.rtf");
        _audioExerciseImageName = @"Tool - Observe Sensations Body Scan Audio Exercise";
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Observe Sensations Body Scan - Intro.rtf");
        _audioURL = resourceURLWithFilename(@"Audio Guide - Observe Sensations Body Scan.mp3");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Observe Sensations Body Scan.plist");
        
        break;
      }
        
      case PTSToolIdentifierObserveThoughtsCloudsInSky: {
        _title = NSLocalizedString(@"Mindfulness: Clouds in the Sky", nil);
        _selfGuidedContentURL = resourceURLWithFilename(@"Tools - Observe Thoughts Clouds in the Sky - Self Guided.rtf");
        _audioExerciseImageName = @"Tool - Observe Thoughts Clouds in the Sky Audio Exercise";
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Observe Thoughts Clouds in the Sky - Intro.rtf");
        _audioURL = resourceURLWithFilename(@"Audio Guide - Observe Thoughts Clouds in the Sky.mp3");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Observe Thoughts Clouds in the Sky.plist");
        
        break;
      }
        
      case PTSToolIdentifierObserveThoughtsLeavesOnStream: {
        _title = NSLocalizedString(@"Mindfulness: Leaves on a Stream", nil);
        _selfGuidedContentURL = resourceURLWithFilename(@"Tools - Observe Thoughts Leaves on a Stream - Self Guided.rtf");
        _audioExerciseImageName = @"Tool - Observe Thoughts Leaves on a Stream Audio Exercise";
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Observe Thoughts Leaves on a Stream - Intro.rtf");
        _audioURL = resourceURLWithFilename(@"Audio Guide - Observe Thoughts Leaves on a Stream.mp3");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Observe Thoughts Leaves on a Stream.plist");
        
        break;
      }
        
      case PTSToolIdentifierPositiveImageryBeach: {
        _title = NSLocalizedString(@"Positive Imagery: Beach", nil);
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Positive Imagery Beach - Intro.rtf");
        _audioExerciseImageName = @"Tool - Positive Imagery Beach";
        _audioURL = resourceURLWithFilename(@"Audio Guide - Positive Imagery Beach.m4a");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Positive Imagery Beach.plist");
        
        break;
      }
        
      case PTSToolIdentifierPositiveImageryCountryRoad: {
        _title = NSLocalizedString(@"Positive Imagery: Country Road", nil);
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Positive Imagery Country Road - Intro.rtf");
        _audioExerciseImageName = @"Tool - Positive Imagery Country Road";
        _audioURL = resourceURLWithFilename(@"Audio Guide - Positive Imagery Country Road.m4a");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Positive Imagery Country Road.plist");
        
        break;
      }
        
      case PTSToolIdentifierPositiveImageryForest: {
        _title = NSLocalizedString(@"Positive Imagery: Forest", nil);
        _audioExerciseIntroURL = resourceURLWithFilename(@"Tools - Positive Imagery Forest - Intro.rtf");
        _audioExerciseImageName = @"Tool - Positive Imagery Forest";
        _audioURL = resourceURLWithFilename(@"Audio Guide - Positive Imagery Forest.m4a");
        _captionsURL = resourceURLWithFilename(@"Audio Guide Captions - Positive Imagery Forest.plist");
        
        break;
      }
        
      case PTSToolIdentifierSoothingAudio: {
        _title = NSLocalizedString(@"Soothing Audio", nil);
        break;
      }
        
      case PTSToolIdentifierSoothingImages: {
        _title = NSLocalizedString(@"Soothing Images", nil);
        break;
      }
        
      case PTSToolIdentifierRID: {
        _title = NSLocalizedString(@"RID", nil);
        break;
      }
        
      case PTSToolIdentifierSootheSenses: {
        _title = NSLocalizedString(@"Soothe the Senses", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Soothe the Senses.plist");
        
        break;
      }
        
      case PTSToolIdentifierThoughtStopping: {
        _title = NSLocalizedString(@"Thought Stopping", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Thought Stopping.plist");
        
        break;
      }
        
      case PTSToolIdentifierTimeOut: {
        _title = NSLocalizedString(@"Time Out", nil);
        _contentURL = resourceURLWithFilename(@"Tools - Time Out.plist");
        
        break;
      }
        
      case PTSToolIdentifierCustom: {
        break;
      }
        
      case PTSToolIdentifierUnknown:
      default: {
        NSAssert(FALSE, @"Invalid tool identifier.");
        break;
      }
    }
  }
  
  return self;
}

#pragma mark - Public Methods

/**
 *  contentURLWithSymptom
 */
- (NSURL *)contentURLWithSymptom:(PTSSymptom *)symptom {
  if (self.identifier != PTSToolIdentifierChangeYourPerspective) {
    return self.contentURL;
  }
  
  return self.symptomSpecificContentURLs[@(symptom.identifier)];
}

@end
