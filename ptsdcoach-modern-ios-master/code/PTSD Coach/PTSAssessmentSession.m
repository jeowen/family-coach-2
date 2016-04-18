//
//  PTSAssessmentSession.m
//  PTSD Coach
//

#import "PTSAssessmentSession.h"
#import "PTSAssessmentAnswer.h"
#import "PTSAssessmentQuestion.h"

static NSArray *sSharedAvailableAnswers;
const NSInteger PTSAssessmentSessionQuestionCount = 20;

#pragma mark - Private Interface

@interface PTSAssessmentSession()

@property(nonatomic, strong, readwrite) NSArray<PTSAssessmentQuestion *> *questions;

@end

#pragma mark - Implementation

@implementation PTSAssessmentSession

#pragma mark - Class Methods

/**
 *  initalize
 */
+ (void)initialize {
  NSMutableArray *mutableAnswers = [[NSMutableArray alloc] init];
  
  [mutableAnswers addObject:[[PTSAssessmentAnswer alloc] initWithText:NSLocalizedString(@"Not at all", nil) pointValue:0]];
  [mutableAnswers addObject:[[PTSAssessmentAnswer alloc] initWithText:NSLocalizedString(@"A little bit", nil) pointValue:1]];
  [mutableAnswers addObject:[[PTSAssessmentAnswer alloc] initWithText:NSLocalizedString(@"Moderately", nil) pointValue:2]];
  [mutableAnswers addObject:[[PTSAssessmentAnswer alloc] initWithText:NSLocalizedString(@"Quite a bit", nil) pointValue:3]];
  [mutableAnswers addObject:[[PTSAssessmentAnswer alloc] initWithText:NSLocalizedString(@"Extremely", nil) pointValue:4]];
  
  sSharedAvailableAnswers = [mutableAnswers copy];
}

#pragma mark - Lifecycle

/**
 *  init
 */
- (instancetype)init {
  self = [super init];
  if (self) {
    [self loadQuestions];
  }
  
  return self;
}

#pragma mark - Public Properties

/**
 *  currentQuestion
 */
- (PTSAssessmentQuestion *)currentQuestion {
  NSAssert(self.currentQuestionIndex >= 0 && self.currentQuestionIndex < self.questions.count, @"Invalid question index");
  
  return self.questions[self.currentQuestionIndex];
}

/**
 *  setCurrentQuestionIndex
 */
- (void)setCurrentQuestionIndex:(NSUInteger)currentQuestionIndex {
  NSAssert(currentQuestionIndex >= 0 && currentQuestionIndex < self.questions.count, @"Invalid current question index");

  _currentQuestionIndex = currentQuestionIndex;
}

/**
 *  isOnFirstQuestion
 */
- (BOOL)isOnFirstQuestion {
  return self.currentQuestionIndex == 0;
}

/**
 *  isOnLastQuestion
 */
- (BOOL)isOnLastQuestion {
  return (self.currentQuestionIndex + 1 == self.questions.count);
}

#pragma mark - Private Methods

/**
 *  loadQuestions
 */
- (void)loadQuestions {
  NSMutableArray *mutableQuestions = [[NSMutableArray alloc] initWithCapacity:PTSAssessmentSessionQuestionCount];
  
  for (NSInteger index = 0; index < PTSAssessmentSessionQuestionCount; index++) {
    NSString *text = [self textForQuestionAtIndex:index];
    NSArray *availableAnswers = [self availableAnswersForQuestionAtIndex:index];
    
    PTSAssessmentQuestion *question = [[PTSAssessmentQuestion alloc] initWithText:text
                                                                 availableAnswers:availableAnswers];

    [mutableQuestions addObject:question];
  }

  self.questions = [mutableQuestions copy];
}

/**
 *  availableAnswersForQuestionAtIndex
 */
- (NSArray *)availableAnswersForQuestionAtIndex:(NSInteger)questionIndex {
  NSParameterAssert(questionIndex >= 0 && questionIndex < PTSAssessmentSessionQuestionCount);

  return sSharedAvailableAnswers;
}
  
/**
 *  textForQuestionAtIndex
 */
- (NSString *)textForQuestionAtIndex:(NSInteger)questionIndex {
  NSParameterAssert(questionIndex >= 0 && questionIndex < PTSAssessmentSessionQuestionCount);
  
  NSString *text;
  
  switch (questionIndex) {
    case 0: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Repeated, disturbing, and unwanted memories of the stressful experience?", nil);
      break;
    }
      
    case 1: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Repeated, disturbing dreams of the stressful experience?", nil);
      break;
    }
      
    case 2: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Suddenly feeling or acting as if the stressful experience were actually happening again (as if you were actually back there reliving it)?", nil);
      break;
    }
      
    case 3: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Feeling very upset when something reminded you of the stressful experience?", nil);
      break;
    }
      
    case 4: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Having strong physical reactions when something reminded you of the stressful experience (for example, heart pounding, trouble breathing, sweating)?", nil);
      break;
    }
      
    case 5: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Avoiding memories, thoughts, or feelings related to the stressful experience?", nil);
      break;
    }
      
    case 6: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Avoiding external reminders of the stressful experience (for example, people, places, conversations, activities, objects, or situations)?", nil);
      break;
    }
      
    case 7: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Trouble remembering important parts of the stressful experience?", nil);
      break;
    }
      
    case 8: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Having strong negative beliefs about yourself, other people, or the world (for example, having thoughts such as: I am bad, there is something seriously wrong with me, no one can be trusted, the world is completely dangerous)?", nil);
      break;
    }
      
    case 9: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Blaming yourself or someone else for the stressful experience or what happened after it?", nil);
      break;
    }
      
    case 10: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Having strong negative feelings such as fear, horror, anger, guilt, or shame?", nil);
      break;
    }
      
    case 11: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Loss of interest in activities that you used to enjoy?", nil);
      break;
    }
      
    case 12: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Feeling distant or cut off from other people?", nil);
      break;
    }
      
    case 13: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Trouble experiencing positive feelings (for example, being unable to feel happiness or have loving feelings for people close to you)?", nil);
      break;
    }
      
    case 14: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Irritable behavior, angry outbursts, or acting aggressively?", nil);
      break;
    }
      
    case 15: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Taking too many risks or doing things that could cause you harm?", nil);
      break;
    }
      
    case 16: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Being “superalert” or watchful or on guard?", nil);
      break;
    }
      
    case 17: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Feeling jumpy or easily startled?", nil);
      break;
    }
      
    case 18: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Having difficulty concentrating?", nil);
      break;
    }
      
    case 19: {
      text = NSLocalizedString(@"In the past month, how much were you bothered by:\n\n"
                               "Trouble falling or staying asleep?", nil);
      break;
    }
      
  }
  
  return text;
}

@end
