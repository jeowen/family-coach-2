//
//  PTSManageSymptomsRootViewController.m
//  PTSD Coach
//

#import "PTSManageSymptomsRootViewController.h"
#import "PTSSymptom.h"
#import "PTSTool.h"
#import "PTSTherapySession.h"
#import "PTSDistressMeterViewController.h"
#import "PTSToolsNavigationController.h"
#import "PTSToolViewDelegate.h"

static NSString *const PTSSegueIdentifierShowDistressMeter = @"ShowDistressMeterSegue";

typedef NS_ENUM(NSInteger, PTSManageSymptomsSegmentedIndex) {
  PTSManageSymptomsSegmentedIndexSymptoms = 0,
  PTSManageSymptomsSegmentedIndexTools = 1
};

#pragma mark - Private Interface

@interface PTSManageSymptomsRootViewController()<UINavigationControllerDelegate>

@property(nonatomic, weak) IBOutlet UIView *symptomsContainerView;
@property(nonatomic, weak) IBOutlet UIView *toolsContainerView;
@property(nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@property(nonatomic, strong) PTSTherapySession *therapySession;

@end

#pragma mark - Implementation

@implementation PTSManageSymptomsRootViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.segmentedControl.selectedSegmentIndex = PTSManageSymptomsSegmentedIndexSymptoms;
  [self handleSegmentedControlValueChanged:self.segmentedControl];
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierShowDistressMeter]) {
    PTSToolsNavigationController *navigationController = (PTSToolsNavigationController *)segue.destinationViewController;
    navigationController.therapySession = self.therapySession;
    
    PTSDistressMeterViewController *distressViewController = (PTSDistressMeterViewController *)navigationController.topViewController;
    distressViewController.therapySession = self.therapySession;
  }
}

#pragma mark - IBActions

/**
 *  handleSegmentedControlValueChanged
 */
- (IBAction)handleSegmentedControlValueChanged:(id)sender {
  if (self.segmentedControl.selectedSegmentIndex == PTSManageSymptomsSegmentedIndexSymptoms) {
    self.symptomsContainerView.hidden = NO;
    self.toolsContainerView.hidden = YES;
  } else if (self.segmentedControl.selectedSegmentIndex == PTSManageSymptomsSegmentedIndexTools) {
    self.symptomsContainerView.hidden = YES;
    self.toolsContainerView.hidden = NO;
  }
}

/**
 *  unwindToManageSymptoms
 */
- (IBAction)unwindToManageSymptoms:(UIStoryboardSegue *)segue {
  // Intentionally left blank.
}

#pragma mark - Public Methods

/**
 *  beginManagementSessionWithSympton
 */
- (void)beginManagementSessionWithSymptom:(PTSSymptom *)symptom {
  self.therapySession = [[PTSTherapySession alloc] initWithInitiatingSymptom:symptom];
  
  [self performSegueWithIdentifier:PTSSegueIdentifierShowDistressMeter sender:nil];
}

/**
 *  beginManagementSessionWithTool
 */
- (void)beginManagementSessionWithTool:(PTSTool *)tool {
  self.therapySession = [[PTSTherapySession alloc] initWithInitiatingTool:tool];
  
  [self performSegueWithIdentifier:PTSSegueIdentifierShowDistressMeter sender:nil];
}

@end
