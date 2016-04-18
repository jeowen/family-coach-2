//
//  PTSToolRIDSummaryViewController.m
//  PTSD Coach
//

#import "PTSToolRIDSummaryViewController.h"
#import "PTSRIDSession.h"
#import "PTSDatastore.h"

#pragma mark - Private Interface

@interface PTSToolRIDSummaryViewController ()

@property(nonatomic, weak) IBOutlet UILabel *decisionLabel;
@property(nonatomic, weak) IBOutlet UILabel *situationLabel;
@property(nonatomic, weak) IBOutlet UILabel *triggeredLabel;

@end

#pragma mark - Implementation

@implementation PTSToolRIDSummaryViewController

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.decisionLabel.text = self.RIDSession.decisionResponse;
  self.situationLabel.text = self.RIDSession.situationExperienceResponse;
  self.triggeredLabel.text = self.RIDSession.triggeringCauseResponse;
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"RIDSummaryExitSegue"]) {
    PTSDatastore *datastore = [PTSDatastore sharedDatastore];
    
    NSMutableArray *mutableSessions = [[NSMutableArray alloc] initWithArray:datastore.RIDSessions];
    [mutableSessions addObject:self.RIDSession];
    
    datastore.RIDSessions = [mutableSessions copy];
  }
}

@end
