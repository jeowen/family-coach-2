//
//  PTSTherapySession.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

@class PTSSymptom;
@class PTSTool;

typedef NS_ENUM(NSInteger, PTSTherapySessionDistressOutcome) {
  PTSTherapySessionDistressOutcomeIncomplete = 0,
  PTSTherapySessionDistressOutcomeUnchanged,
  PTSTherapySessionDistressOutcomeIncreased,
  PTSTherapySessionDistressOutcomeDecreased
};

typedef NS_ENUM(NSInteger, PTSTherapySessionContext) {
  PTSTherapySessionContextSymptom = 1,
  PTSTherapySessionContextTool
};

@interface PTSTherapySession : NSObject

// Public Properties
@property(nonatomic, assign, readonly) PTSTherapySessionContext context;
@property(nonatomic, strong, readonly) PTSSymptom *initiatingSymptom;
@property(nonatomic, strong, readonly) PTSTool *initiatingTool;
@property(nonatomic, strong, readonly) PTSTool *currentTool;

@property(nonatomic, assign, readonly) BOOL hasRecordedInitialDistressLevel;
@property(nonatomic, assign, readonly) PTSTherapySessionDistressOutcome distressOutcome;
@property(nonatomic, assign) NSInteger distressLevel;

// Initializers
- (instancetype)initWithInitiatingSymptom:(PTSSymptom *)symptom;
- (instancetype)initWithInitiatingTool:(PTSTool *)tool;

// Public Methods
- (void)prescribeNewTool;
- (UIViewController *)instantiateViewControllerForCurrentTool;

@end
